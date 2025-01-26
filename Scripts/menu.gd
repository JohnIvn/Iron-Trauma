extends Control
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Map/level1.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Main Menu/multiplayer_ui.tscn")


func _on_demo_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Map/demo.tscn")
