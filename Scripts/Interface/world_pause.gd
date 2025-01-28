extends Node2D

var isPause = false

# Sets Time Scale to default and Mouse Mode to Captured
func _ready() -> void:
	Engine.time_scale = 1.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_cancel'):
		isPause = !isPause
		if isPause:
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if !isPause:
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
func _set_pause(status: bool) -> void:
	isPause = status
