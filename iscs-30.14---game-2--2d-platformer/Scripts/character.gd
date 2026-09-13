extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_timer: Timer = $RespawnTimer
@export var dash_speed = 400
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const SPAWNPOINT = Vector2(152.0,-48.0)
var is_alive: bool = true
var can_respawn:bool = true
var lives: int = 3
var double_jump_unlocked: bool = false
var can_double_jump: bool = false
var dash_unlocked: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var last_direction = -1.0
signal update_lives_count(lives)

func _ready() -> void:
	SignalBus.player_died.connect(death)
	SignalBus.player_gained_life.connect(pick_up_life)

func _physics_process(delta: float) -> void:
	if is_alive:
		# Add the gravity.
		if not is_on_floor() and not is_dashing:
			velocity += get_gravity() * delta
			
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction and not is_dashing:
			velocity.x = direction * SPEED
			last_direction = direction
		elif not is_dashing:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if direction > 0:
			animations.flip_h = true
		elif direction < 0:
			animations.flip_h = false
		
		if is_dashing:
			animations.play("dashing")
		
		if Input.is_action_just_pressed("dash") and can_dash and dash_unlocked:
			can_dash = false
			is_dashing = true
			set_process_input(false)
			velocity.x = last_direction * dash_speed
			velocity.y = 0
			await tween(self,"dash_speed",0,0.2).finished
			is_dashing = false
			dash_speed = 400
			set_process_input(true)
			await (get_tree().create_timer(0.7).timeout)
			can_dash = true
		
		# Handle jump.
		if is_jumping_on_ground() and not is_dashing:
			velocity.y = JUMP_VELOCITY
			animations.play("jump")
		elif is_double_jumping() and not is_dashing:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
			animations.play("jump")
		elif is_on_floor():
			can_double_jump = true
			if direction == 0 and not is_dashing:
				animations.play("idle")
			elif not is_dashing:
				animations.play("walking")

		move_and_slide()

func is_jumping_on_ground():
	return Input.is_action_just_pressed("ui_accept") and is_on_floor()

func is_double_jumping():
	return Input.is_action_just_pressed("ui_accept") and can_double_jump and double_jump_unlocked

func unlock_double_jump():
	double_jump_unlocked = true

func jump_on_enemy():
	velocity.y = JUMP_VELOCITY

func death():
	if is_alive:
		is_alive = false
		lives -= 1
		if lives == 0:
			can_respawn = false
		update_lives_count.emit(lives)
		Engine.time_scale = 0.5
		var tween = create_tween()
		respawn_timer.start()
		tween.tween_property(animations,"position",Vector2(0,-20),0.1)
		tween.tween_property(animations,"position",Vector2(0,200),0.4)
		if can_respawn:
			tween.tween_property(animations,"position",Vector2(0,0),0)

func respawn():
	if can_respawn:
		global_position = SPAWNPOINT
		is_alive = true
		Engine.time_scale = 1.0
		print(lives)
	
func unlock_dash():
	dash_unlocked = true

func pick_up_life():
	lives += 1

func tween(node,property,target_value,duration):
	var tween = create_tween()
	tween.tween_property(node,property,target_value,duration)
	tween.EASE_OUT
	return tween
