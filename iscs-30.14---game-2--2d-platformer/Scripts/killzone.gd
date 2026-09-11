extends Area2D
# This is a reusable node for any form of Killzone.
# To use it, drag this scene from the Scenes folder into any node that
# will have a killzone. Then, add a CollisionShape2D child node to it
# and set its shape. This should make the Killzone work.
var enemy_dying: bool = false

func _on_body_entered(_body: Node2D) -> void:
	if enemy_dying:
		return
	else:
		var y_delta = global_position.y - _body.global_position.y
		print(y_delta)
		if (y_delta > 9):
			enemy_dying = true
			print ("kill enemy")
			_body.jump_on_enemy()
			var enemy = get_parent()
			var enemy_sprite = enemy.get_node_or_null("AnimatedSprite2D")
			#$".".set_deferred("disabled", true)
			enemy.set_physics_process(false)
			enemy_sprite.play("death")
			await enemy_sprite.animation_finished
			enemy.queue_free()
		else:
			print("Death!")
			SignalBus.player_died.emit()

# Useless function. Erase this + the Timer at the end when you're sure of
# no bugs.
func _on_timer_timeout() -> void:
	pass
	# Engine.time_scale = 1.0
	# get_tree().reload_current_scene()
