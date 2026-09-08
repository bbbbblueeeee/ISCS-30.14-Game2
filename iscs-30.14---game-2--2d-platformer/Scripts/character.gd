extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var double_jump_unlocked: bool = false
var can_double_jump: bool = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0:
		animations.flip_h = true
	elif direction < 0:
		animations.flip_h = false
	
	# Handle jump.
	if is_jumping_on_ground():
		velocity.y = JUMP_VELOCITY
		animations.play("jump")
	elif is_double_jumping():
		velocity.y = JUMP_VELOCITY
		can_double_jump = false
		animations.play("jump")
	elif is_on_floor():
		can_double_jump = true
		if direction == 0:
			animations.play("idle")
		else:
			animations.play("walking")

	move_and_slide()

func is_jumping_on_ground():
	return Input.is_action_just_pressed("ui_accept") and is_on_floor()

func is_double_jumping():
	return Input.is_action_just_pressed("ui_accept") and can_double_jump and double_jump_unlocked

func unlock_double_jump():
	double_jump_unlocked = true
