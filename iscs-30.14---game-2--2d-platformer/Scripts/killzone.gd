extends Area2D
# This is a reusable node for any form of Killzone.
# To use it, drag this scene from the Scenes folder into any node that
# will have a killzone. Then, add a CollisionShape2D child node to it
# and set its shape. This should make the Killzone work.


func _on_body_entered(_body: Node2D) -> void:
	print("Death!")
	SignalBus.player_died.emit()

# Useless function. Erase this + the Timer at the end when you're sure of
# no bugs.
func _on_timer_timeout() -> void:
	pass
	# Engine.time_scale = 1.0
	# get_tree().reload_current_scene()
