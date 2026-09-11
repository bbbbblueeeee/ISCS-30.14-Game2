extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var min_x: float = 650.0
@export var max_x: float = 1100.0

const SPEED = 50.0
var direction = -1.0

func _physics_process(_delta: float) -> void:
	# Apply movement velocity
	velocity.x = direction * SPEED

	# Move using physics collision engine
	move_and_slide()

	# Turn around if hitting a wall
	if global_position.x <= min_x or global_position.x >= max_x:
		direction *= -1.0
		sprite.flip_h = (direction > 0)
