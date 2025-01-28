extends Control

@onready var player: CharacterBody2D = $"../.."
@onready var stamina: ProgressBar = $Control/Panel/Stamina
@onready var health: ProgressBar = $Control/Panel/Health

var stamina_value = 0.0
var health_value = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stamina_value = player.baseStamina
	stamina.value = stamina_value
#	health_value = player.baseHealth
