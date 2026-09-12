extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var text: Label = $"Collect Text"

signal player_unlocked_double_jump

func _ready() -> void:
	text.hide()

func _on_body_entered(_body: Node2D) -> void:
	player_unlocked_double_jump.emit()
	hitbox.queue_free()
	sprite.queue_free()
	text.show()
	await (get_tree().create_timer(5).timeout)
	text.hide()
