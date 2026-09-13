extends Node2D

# To use: Add this scene into the world, then attach a corresponding
# AnimatedSprite2D texture to it with the character texture you want.

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var left_ray: RayCast2D = $Left
@onready var right_ray: RayCast2D = $Right
@onready var label: Label = $Label
@onready var interact_key: Label = $InteractKey
@onready var npc_area: Area2D = $"NPC Area"
@onready var collision_shape_2d: CollisionShape2D = $"NPC Area/CollisionShape2D"
const SPEED = 60
var direction = 1
var is_colliding = false
var is_showing_text = false
var can_show_interact_key = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.flip_h = true
	label.hide()
	interact_key.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if right_ray.is_colliding():
		direction = -1
		sprite.flip_h = false
	if left_ray.is_colliding():
		direction = 1
		sprite.flip_h = true
		
	
	position.x += direction * SPEED * delta
	detect_player_interaction()

func detect_player_interaction():
	if Input.is_action_pressed("Interact") and is_colliding and !is_showing_text:
		is_showing_text = true
		can_show_interact_key = false
		interact_key.hide()
		label.show()
		await (get_tree().create_timer(5).timeout)
		label.hide()
		is_showing_text = false
		can_show_interact_key = true


func _on_npc_area_body_entered(body: Node2D) -> void:
	is_colliding = true
	show_interact_key()
	

func _on_npc_area_body_exited(body: Node2D) -> void:
	is_colliding = false
	interact_key.hide()
	
func show_interact_key():
	if can_show_interact_key:
		interact_key.show()
	else:
		interact_key.hide()
