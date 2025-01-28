extends Control

@onready var pause: Control = self

var isPause = false

func _ready() -> void:
	get_tree().paused = false
	visible = false 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_cancel'):
		_toggle_pause()

func _toggle_pause() -> void:
	isPause = !isPause
	if isPause:
		get_tree().paused = true
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		get_tree().paused = false
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func _on_continue_pressed() -> void:
	_toggle_pause()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Interface/menu.tscn")
