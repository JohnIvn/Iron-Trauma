extends CharacterBody2D

# Nodes
@onready var PlayerSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var StaminaBar: ProgressBar = $CanvasLayer/Control/ProgressBar
@onready var PlayerFootsteps: AudioStreamPlayer2D = $Footsteps
@onready var GunShot: AudioStreamPlayer2D = $Gunshot
@onready var StaminaOut: AudioStreamPlayer2D = $"Stamina Out"
@onready var Splatter: AudioStreamPlayer2D = $"Splatter"
@onready var light: PointLight2D = $PointLight2D

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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Engine.time_scale = 1.0
	shootCD = shootDur
	baseStamina = maxStamina

func _process(delta: float) -> void:
	#print(PlayerSprite.animation) # For Debugging Animation
# Mouse Mode
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_mode = true
		if !isPause:
			_pause_game(true)
		else:
			_pause_game(false)
	if isPause:
		return
	
	if Input.is_action_just_pressed("ui_cancel") && mouse_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_mode = false
	
	if Input.is_action_just_pressed('surprise') and isEquiped:
		if !isShooting:
			if !StaminaOut.playing:
				StaminaOut.play()
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
	StaminaBar.value = baseStamina
	
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
			isShooting = true
			PlayerSprite.stop()
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
	elif !isMoving and !isSprint:
		if !isEquiped:
			PlayerSprite.play("idle")
		else:
			PlayerSprite.play('idle_gun')

# Death Variables
var isDead

func _death(delta):
	if isDead:
		#Engine.time_scale = 0.75
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
	
@onready var deadBodies: Array = []
var deadBody: Sprite2D

func _create_dead_body():
	var newDeadBody = Sprite2D.new()
	var texture = preload("res://Assets/Images/Human/Marine Gun/Death/Surprise17.png")
	if isLeft:
		newDeadBody.flip_h = true
	newDeadBody.position = position
	newDeadBody.texture = texture
	newDeadBody.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	newDeadBody.z_index = -1

# Adds body based on world node, stores into an array
	get_parent().add_child(newDeadBody)
	deadBodies.append(newDeadBody)

func _pause_game(pause: bool) -> void:
	isPause = pause
	if pause:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GunShot.stream_paused = true
		Splatter.stream_paused = true
		StaminaOut.stream_paused = true
		PlayerFootsteps.stream_paused = true
		Engine.time_scale = 0.0
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GunShot.stream_paused = false
		Splatter.stream_paused = false
		StaminaOut.stream_paused = false
		PlayerFootsteps.stream_paused = false
		Engine.time_scale = 1.0

func _on_animated_sprite_2d_animation_finished() -> void:
	if PlayerSprite.animation == "fire_gun" and PlayerSprite.frame == 8:
		isShooting = false
		GunShot.pitch_scale = 0.75
