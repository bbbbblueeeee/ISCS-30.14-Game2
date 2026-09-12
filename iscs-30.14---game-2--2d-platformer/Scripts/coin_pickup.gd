extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var text: Label = $"Collect Text"

signal player_unlocked_dash

func _ready() -> void:
	text.hide()

func _on_body_entered(_body: Node2D) -> void:
	print("hey")
	player_unlocked_dash.emit()
	hitbox.queue_free()
	sprite.queue_free()
	text.show()
	await (get_tree().create_timer(5).timeout)
	text.hide()
