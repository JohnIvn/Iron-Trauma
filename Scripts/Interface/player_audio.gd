extends Node2D

@onready var player: CharacterBody2D = $".."

var PlayerSounds = {
	"shoot": preload("res://Assets/Audio/Player/gunfire.mp3"),
	"move": preload("res://Assets/Audio/Player/footsteps.mp3"),
	"tired": preload("res://Assets/Audio/Player/heavy_breathing.mp3"),
	"death_gore": preload("res://Assets/Audio/Player/splat.mp3")
}

func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player.isDead:
		pass
