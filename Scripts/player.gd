extends CharacterBody2D

const Speed = 300.0

var _animationPlayer: AnimationPlayer

func _ready():
	_animationPlayer = $WalkingAnimation

func _physics_process(_delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += Speed
		if _animationPlayer:
			_animationPlayer.play("walking_right")
	elif Input.is_action_pressed("move_left"):
		velocity.x -= Speed
		if _animationPlayer:
			_animationPlayer.play("walking_left")
			

	if Input.is_action_pressed("move_down"):
		velocity.y += Speed
		
	elif Input.is_action_pressed("move_up"):
		velocity.y -= Speed
			
	if velocity == Vector2.ZERO and _animationPlayer:
		_animationPlayer.stop()

	move_and_slide()
