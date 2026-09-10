extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_timer: Timer = $RespawnTimer
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const SPAWNPOINT = Vector2(152.0,-48.0)
var is_alive: bool = true
var lives: int = 3
var double_jump_unlocked: bool = false
var can_double_jump: bool = false

func _ready() -> void:
	SignalBus.player_died.connect(death)

func _physics_process(delta: float) -> void:
	if is_alive:
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

func death():
	if is_alive:
		is_alive = false
		lives -= 1
		Engine.time_scale = 0.5
		var tween = create_tween()
		respawn_timer.start()
		tween.tween_property(animations,"position",Vector2(0,-20),0.1)
		tween.tween_property(animations,"position",Vector2(0,200),0.4)
		tween.tween_property(animations,"position",Vector2(0,0),0)

func respawn():
	global_position = SPAWNPOINT
	is_alive = true
	Engine.time_scale = 1.0
	print(lives)
