extends CanvasLayer

@onready var life_1: AnimatedSprite2D = $Life1
@onready var life_2: AnimatedSprite2D = $Life2
@onready var life_3: AnimatedSprite2D = $Life3
@onready var death_text: Label = $"Death Text"
var life_tracker: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_gained_life.connect(increase_life)
	death_text.hide()
	life_1.play("full")
	life_2.play("full")
	life_3.play("full")
	life_tracker = 3
	

func reduce_life(life_reference):
	life_tracker = clamp(life_reference,0,3)
	if life_tracker == 2:
		life_3.play("empty")
	elif life_tracker == 1:
		life_2.play("empty")
	else:
		life_1.play("empty")
	
	calculate_if_failed()


func increase_life():
	life_tracker = clamp(life_tracker+1,0,3)
	if life_tracker == 2:
		life_2.play("full")
	elif life_tracker == 3:
		life_3.play("full")
	

func calculate_if_failed():
	if life_tracker == 0:
		death_text.show()
