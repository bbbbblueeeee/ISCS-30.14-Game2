extends Area2D
# This is a reusable node for any form of Killzone.
# To use it, drag this scene from the Scenes folder into any node that
# will have a killzone. Then, add a CollisionShape2D child node to it
# and set its shape. This should make the Killzone work.

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	print("Death!")
	timer.start()

# Need to change how this works if you want to do lives
# Reloading the current scene resets everything
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
