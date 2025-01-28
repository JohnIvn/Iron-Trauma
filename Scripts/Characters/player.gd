extends CharacterBody2D

# Nodes
@onready var PlayerSprite: AnimatedSprite2D = $PlayerSprite
@onready var light: PointLight2D = $PlayerVisuals/PointLight

@onready var PlayerFootsteps: AudioStreamPlayer2D = $AudioStreamer/Footsteps
@onready var GunShot: AudioStreamPlayer2D = $AudioStreamer/Gunshot
@onready var StaminaOut: AudioStreamPlayer2D = $"AudioStreamer/Stamina Out"
@onready var Splatter: AudioStreamPlayer2D = $AudioStreamer/Splatter



# Variables
@export var acceleration = 10.0
@export var sprintSpeed = 150.0
@export var walkSpeed = 75.0
var baseSpeed = 0.0

# Health
@export var maxStamina = 100.0
@export var depletionRate = 100.0
@export var recoveryRate = 35.5
var baseStamina = 0.0	

# Mechanics Variables
var isMoving = false
var isSprint = false
var staminaInterval = 5.0
var staminaCooldown

# Vectors and Others
var input: Vector2
@export var respawn_delay: float = 1.0

var mouse_mode = false
var isPause = false
	
func _ready() -> void:
	Engine.time_scale = 1.0
	shootCD = shootDur
	baseStamina = maxStamina

func _process(delta: float) -> void:
# Mouse Mode
	if Input.is_action_just_pressed('surprise'):
		if !isShooting:
			PlayerSprite.speed_scale = 1.0
			isDead = true

	if !isDead:
# Animation Handler
		_animation_handler()
# Movement Handler
		_movement_handler(delta)
# Gun Handler
		_handle_guns()
	else:
		_death(delta)

func _get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength('move_left')
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength('move_up')
	
	return input.normalized()
	
func _movement_handler(delta):
	if !isShooting and !isDead:
		var playerInput = _get_input()
		velocity = lerp(velocity, playerInput * baseSpeed, delta * acceleration)
		move_and_slide()
		
# Sprint Mechanism
	if Input.is_action_pressed('sprint') and baseStamina > 0 and isMoving and !isEquiped:
		isSprint = true
	else:
		isSprint = false

	if isSprint:
		baseSpeed = sprintSpeed
		baseStamina -= depletionRate * delta
		baseStamina = clamp(baseStamina, 0, maxStamina)
		if baseStamina <= 0:
			isSprint = false
			staminaCooldown = true
	else:
		baseSpeed = walkSpeed

		if staminaCooldown:
			if !StaminaOut.playing:
				StaminaOut.play()
			PlayerFootsteps.pitch_scale = 0.75
			PlayerSprite.speed_scale = 0.5
			baseSpeed -= baseSpeed * 0.75
			staminaInterval -= delta 
			if staminaInterval <= 0:
				staminaCooldown = false 
				staminaInterval = 3.0 
		else:
			StaminaOut.stop()
			PlayerSprite.speed_scale = 1.0
			baseSpeed = walkSpeed
			baseStamina += recoveryRate * delta
			baseStamina = clamp(baseStamina, 0, maxStamina)

# Temporary Variables
var isEquiped = false
var isShooting = false
var shootDur = 1.0
var shootCD = 0.0
var isLeft = false

# All In Dev (Might not be a future feature)
func _handle_guns():
	if Input.is_action_just_pressed('weapon'):
		isEquiped = !isEquiped
		
	if isEquiped:
		if Input.is_action_just_pressed('attack') and !isShooting:
			print('shooting')
			isShooting = true
			if !PlayerSprite.animation == "fire_gun":
				PlayerSprite.play("fire_gun")
			GunShot.pitch_scale = 2.5
			GunShot.play()

	if isShooting:
		PlayerFootsteps.stop()

func _animation_handler():
	if input.x != 0 or input.y != 0:
		isMoving = true
		if !PlayerFootsteps.playing:
			PlayerFootsteps.play()  
	else:
		PlayerFootsteps.stop()
		isMoving = false

# Flip sprite based on input
	if Input.is_action_pressed("move_left"):
		isLeft = true
		if !isShooting:
			PlayerSprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		isLeft = false
		if !isShooting:
			PlayerSprite.flip_h = false

# Play animations based on state
	if isMoving and !isSprint and !isShooting:
		PlayerFootsteps.pitch_scale = 1.5
		if isEquiped:
			PlayerSprite.play('walk_gun')
		else:
			PlayerSprite.play("walk")
	elif isSprint and isMoving and !isEquiped:
		PlayerFootsteps.pitch_scale = 2.5
		PlayerSprite.play("run")
	elif !isMoving and !isSprint and !isShooting:
		if !isEquiped:
			PlayerSprite.play("idle")
		else:
			PlayerSprite.play('idle_gun')

# Death Variables
var isDead

func _death(delta):
	if isDead:
		if !StaminaOut.playing:
			StaminaOut.play()
		PlayerFootsteps.stop()
		PlayerSprite.play('surprise')
		if PlayerSprite.frame == 1:
			GunShot.pitch_scale = 1.1
			GunShot.play()
		if PlayerSprite.frame == 1 and !Splatter.playing:
			Splatter.pitch_scale = 0.6
			Splatter.play()
		if PlayerSprite.frame == 6:
			StaminaOut.stop()
			light.energy = 10
		if PlayerSprite.frame == 7:
			light.energy = 1
			light.color = Color(0.911, 0.067, 0.04)
		if PlayerSprite.frame == 16:
			Splatter.stop()
			PlayerSprite.frame = 16
			staminaCooldown = false
			_start_respawn() 
			_create_dead_body()

func _set_position(new_position: Vector2):
	position = new_position
	
func _start_respawn():
	# Disable movement and input for respawn
	set_process_input(false)
	set_process(false)

	# Wait for respawn delay before respawning the player
	await get_tree().create_timer(respawn_delay).timeout

	# Call respawn logic
	_respawn_player()
	
func _respawn_player():
# Reset player position and status
	light.color = Color(255.0 / 255.0, 249.0 / 255.0, 178.0 / 255.0)
	position = Vector2(0, 0)  # Reset position (or use your spawn logic)
	baseStamina = maxStamina
	isDead = false
	PlayerSprite.play("idle")  # You can play any animation you like for respawn

	# Enable player controls again
	set_process_input(true)
	set_process(true)

# Is fixed and finalized
@onready var deadBodies: Array = []
var deadBody: Sprite2D
func _create_dead_body():
	var newDeadBody = Sprite2D.new()
	var texture = preload("res://Assets/Images/Characters/Human (Equipped)/Death/Surprise17.png")
	if isLeft:
		newDeadBody.flip_h = true
	newDeadBody.position = position
	newDeadBody.texture = texture
	newDeadBody.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	newDeadBody.z_index = -1

	get_parent().add_child(newDeadBody)
	deadBodies.append(newDeadBody)

func _on_animated_sprite_2d_animation_finished() -> void:
	if PlayerSprite.animation == "fire_gun" and PlayerSprite.frame == 8:
		print("Shooting Finished")
		isShooting = false
		GunShot.pitch_scale = 0.75
