extends Control

@onready var pause: Control = $"."
@onready var player: CharacterBody2D = $"../.."

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_cancel'):
		if !pause.visible:
			pause.visible = true
		else:
			pause.visible = false
		
func _on_continue_pressed() -> void:
	player._pause_game(false)
	pause.visible = false

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Main Menu/menu.tscn")
