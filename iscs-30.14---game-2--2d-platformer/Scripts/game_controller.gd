extends Node2D

@onready var character: CharacterBody2D = $Character
@onready var diamond_pickup: Area2D = $"Diamond Pickup"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	diamond_pickup.player_unlocked_double_jump.connect(character.unlock_double_jump)
	get_node("AudioStreamPlayer").playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
