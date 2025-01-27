extends Node2D

var isNear = false
var isOpen = false
var picked = false
@onready var OpenedNote: CanvasLayer = $CanvasLayer
@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var Note: Area2D = $Area2D

func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	OpenedNote.visible = isOpen
	if Input.is_action_just_pressed('interact'):
		isOpen = !isOpen
		if isNear and !picked: 
			picked = true
			Note.queue_free()
			print("Note picked up")
	if Input.is_action_just_pressed('surprise'):
		isOpen = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "Player":
		print("Player Near")
		isNear = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		isNear = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "Player":
		print("Player Near")
		isNear = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player":
		isNear = false
