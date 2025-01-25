extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var staminaBar: ProgressBar = $CanvasLayer/Control/ProgressBar

@export var ACCEL = 1.0

@export var sprintSpeed = 300.0
@export var walkSpeed = 100.0
var baseSpeed = 0.0

@export var maxStamina = 100.0
@export var depletionRate = 50.0
@export var recoveryRate = 35.5
var baseStamina = 0.0

var input: Vector2

func _ready() -> void:
	baseStamina = maxStamina

func _get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength('move_left')
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength('move_up')
	
	return input.normalized()
	
var isSprint = false
var staminaInterval = 3.0
var staminaCooldown
	
func _process(delta: float) -> void:
	
	staminaBar.value = baseStamina
	_animation_handler()
	var playerInput = _get_input()
	
	if Input.is_action_pressed('sprint') and baseStamina > 0 and isMoving:
		isSprint = true
		baseSpeed = sprintSpeed
		animated_sprite_2d.speed_scale = 2.0
		baseStamina -= depletionRate * delta
		baseStamina = clamp(baseStamina, 0, maxStamina)
		if baseStamina <= 0:
			isSprint = false
			staminaCooldown = true
	
	else:
		isSprint = false
		animated_sprite_2d.speed_scale = 1.0
		baseSpeed = walkSpeed
		
	if !isSprint:
		if staminaCooldown:
			staminaInterval -= delta 
			if staminaInterval <= 0:
				staminaCooldown = false 
				staminaInterval = 3.0 

		else:
			baseStamina += recoveryRate * delta
			baseStamina = clamp(baseStamina, 0, maxStamina)
			
	velocity = lerp(velocity, playerInput * baseSpeed, delta * ACCEL)
	
	move_and_slide()

var isMoving = false
var isLevt = false

func _animation_handler():
	if input.x != 0 or input.y != 0:
		isMoving = true
	else:
		isMoving = false
	
	if Input.is_action_pressed("move_left"):
		animated_sprite_2d.flip_h = true
		sprite_2d.flip_h = true
	if Input.is_action_pressed("move_right"):
		animated_sprite_2d.flip_h = false
		sprite_2d.flip_h = false
	
	if isMoving:
		sprite_2d.visible = false
		animated_sprite_2d.visible = true
		animated_sprite_2d.play()
	else:
		sprite_2d.visible = true
		animated_sprite_2d.visible = false

func drain():
	baseSpeed = 0.0
		
