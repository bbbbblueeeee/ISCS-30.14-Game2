extends Node2D

@onready var character: CharacterBody2D = $Character
@onready var diamond_pickup: Area2D = $"Diamond Pickup"
@onready var life_controller: CanvasLayer = $LifeController


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	diamond_pickup.player_unlocked_double_jump.connect(character.unlock_double_jump)
	character.update_lives_count.connect(life_controller.reduce_life)
	get_node("AudioStreamPlayer").playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
