extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 25.0
var direction = -1.0

func _physics_process(_delta: float) -> void:
	# Apply movement velocity
	velocity.x = direction * SPEED

	# Move using physics collision engine
	move_and_slide()

	# Turn around if hitting a wall
	if is_on_wall():
		direction *= -1.0
		sprite.flip_h = (direction > 0)
