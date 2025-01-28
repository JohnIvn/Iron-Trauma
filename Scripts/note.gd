extends StaticBody2D

var isNear = false
var isOpen = false
var picked = false
@onready var OpenedNote: CanvasLayer = $CanvasLayer
#@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var Note: Area2D = $Area2D
@onready var NoteSprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var player = null

func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	OpenedNote.visible = isOpen
	if Input.is_action_just_pressed('interact'):
		isOpen = !isOpen
		if isNear and !picked: 
			NoteSprite.queue_free()
			picked = true
			Note.queue_free()
			print("Note picked up")
			timer.start()
	if Input.is_action_just_pressed('surprise'):
		isOpen = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	#print(area.name)
	if area.name == "Player":
		#print("Player Near")
		isNear = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player":
		isNear = false

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	print("Hello")
	if body.is_in_group("player"):
		print("Yes")
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("World")

func _on_timer_timeout() -> void:
	player.isDead = true
	isOpen = false
