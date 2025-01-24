extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var SPEED = 100.0
@export var ACCEL = 1.0

var input: Vector2

func _get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength('move_left')
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength('move_up')
	
	return input.normalized()
	
func _process(delta: float) -> void:
	_animation_handler()
	var playerInput = _get_input()
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	
	move_and_slide()

var isMoving = false
var isLevt = false

func _animation_handler():
	if input.x != 0 or input.y != 0:
		isMoving = true
	else:
		isMoving = false
	
	if Input.is_action_just_pressed("move_left"):
		animated_sprite_2d.flip_h = true
		sprite_2d.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		animated_sprite_2d.flip_h = false
		sprite_2d.flip_h = false
	
	if isMoving:
		sprite_2d.visible = false
		animated_sprite_2d.visible = true
		animated_sprite_2d.play()
	else:
		sprite_2d.visible = true
		animated_sprite_2d.visible = false
