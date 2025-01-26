extends CharacterBody2D

# Nodes
@onready var PlayerSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var StaminaBar: ProgressBar = $CanvasLayer/Control/ProgressBar
@onready var PlayerFootsteps: AudioStreamPlayer2D = $Footsteps
@onready var GunShot: AudioStreamPlayer2D = $Gunshot

# Variables
# Speed
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
# Movement
var isMoving = false
var isSprint = false
var staminaInterval = 5.0
var staminaCooldown

# Vectors and Others
var mouse_mode = false
var input: Vector2

func _ready() -> void:
	shootCD = shootDur
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Engine.time_scale = 1.0
	baseStamina = maxStamina

func _process(delta: float) -> void:
	print(PlayerSprite.animation)

# Mouse Mode
	if Input.is_action_just_pressed("ui_cancel") && !mouse_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_mode = true
	elif Input.is_action_just_pressed("ui_cancel") && mouse_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_mode = false
	elif Input.is_action_just_pressed('surprise') and isEquiped:
		if !isShooting:
			isDead = true
		
	if !isDead:
# Animation Handler
		_animation_handler()
# Movement Handler
		_movement_handler(delta)
# Gun Handler
		_handle_guns()
	else:
		_death()

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
			PlayerFootsteps.pitch_scale = 0.75
			PlayerSprite.speed_scale = 0.5
			baseSpeed -= baseSpeed * 0.75
			staminaInterval -= delta 
			if staminaInterval <= 0:
				staminaCooldown = false 
				staminaInterval = 3.0 
		else:
			PlayerSprite.speed_scale = 1.0
			baseSpeed = walkSpeed
			baseStamina += recoveryRate * delta
			baseStamina = clamp(baseStamina, 0, maxStamina)

# Temporary Variables
var isEquiped = false
var heavyFactor = 1.5

var isShooting = false
var shootDur = 1.0
var shootCD = 0.0

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
		PlayerSprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		PlayerSprite.flip_h = false
	

# Gun Sprite Changes
	if isEquiped and !isShooting and !isMoving:
		PlayerSprite.play('idle_gun')

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

var isDead

func _death():
	if isDead:
		Engine.time_scale = 0.75
		PlayerFootsteps.stop()
		PlayerSprite.play('surprise')
		if PlayerSprite.frame == 1:
			GunShot.play()
		if PlayerSprite.frame == 16:
			PlayerSprite.frame = 16

func _on_animated_sprite_2d_animation_finished() -> void:
	if PlayerSprite.animation == "fire_gun" and PlayerSprite.frame == 8:
		isShooting = false
		GunShot.pitch_scale = 0.75
