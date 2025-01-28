extends Node2D

const PLAYER = preload("res://Nodes/Character/Player/player.tscn")

@export var spawn_position: Vector2 = Vector2(0, 0)
@onready var player: CharacterBody2D = $Player

func _ready():
	spawn_player()

func spawn_player():
	var player_scene = PLAYER

	if player:
		player.queue_free()
		
	player = player_scene.instantiate()
	
	add_child(player)
	
	if player.has_method("set_position"):
		player.set_position(spawn_position)
	else:
		player.position = spawn_position


func _on_player_player_died() -> void:
	await get_tree().create_timer(1.0).timeout
	spawn_player()
