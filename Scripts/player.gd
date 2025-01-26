extends CharacterBody2D
# Nodes
@onready var PlayerSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var StaminaBar: ProgressBar = $CanvasLayer/Control/ProgressBar
@onready var PlayerFootsteps: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Constants

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

# Vectors
var input: Vector2

func _ready() -> void:
	baseStamina = maxStamina

func _process(delta: float) -> void:
# Animation Handler
	_animation_handler()
# Movement Handler
	_movement_handler(delta)

func _get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength('move_left')
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength('move_up')
	
	return input.normalized()

func _movement_handler(delta):
	var playerInput = _get_input()
	StaminaBar.value = baseStamina

# General Movement
	velocity = lerp(velocity, playerInput * baseSpeed, delta * acceleration)
	move_and_slide()

# Sprint Mechanism
	if Input.is_action_pressed('sprint') and baseStamina > 0 and isMoving:
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

func _animation_handler():
	# Check for movement
	if input.x != 0 or input.y != 0:
		if !PlayerFootsteps.is_playing():
			PlayerFootsteps.play()
		isMoving = true
	else:
		PlayerFootsteps.stop()
		isMoving = false   
		 
# Flip sprite based on input
	if Input.is_action_pressed("move_left"):
		PlayerSprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		PlayerSprite.flip_h = false

# Play animations based on state
	if isMoving and !isSprint:
		PlayerFootsteps.pitch_scale = 1.5
		PlayerSprite.play("walk")
	elif isSprint and isMoving:
		PlayerFootsteps.pitch_scale = 2.5
		PlayerSprite.play("run")
	elif !isMoving and !isSprint:
		PlayerSprite.play("idle")
