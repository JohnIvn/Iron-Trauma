extends StaticBody2D

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../CharacterBody2D"

var isNear = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if isNear and Input.is_action_pressed('interact'):
		sprite2D.modulate = Color(0.057, 0.565, 0.003)

func _on_detecion_area_entered(area: Area2D) -> void:
	print("Player Area near")
	isNear = true

func _on_detecion_body_entered(body: Node2D) -> void:
	print("Player Body near")
	isNear = true

func _on_detecion_body_exited(body: Node2D) -> void:
	print("Player Body left")
	sprite2D.modulate = Color(0.0, 0.0, 0.0)
	isNear = false

func _on_detecion_area_exited(area: Area2D) -> void:
	print("Player Body left")
	sprite2D.modulate = Color(0.0, 0.0, 0.0)
	isNear = false
