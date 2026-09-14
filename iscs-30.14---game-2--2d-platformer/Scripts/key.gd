extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var text: Label = $"Collect Text"

func _ready() -> void:
	text.hide()
	sprite.hide()
	hitbox.set_deferred("disabled", true)

func _enemy_killed() -> void:
	sprite.show()
	hitbox.set_deferred("disabled", false)

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.player_gained_key.emit()
	hitbox.queue_free()
	sprite.queue_free()
	text.show()
	await get_tree().create_timer(5.0).timeout
	get_parent().queue_free()
