extends Node2D

@onready var level = $Level

const SCALE_MIN = 0.3
const SCALE_MAX = 1
const SCALE_STEP = 0.01

var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		if level.scale.x < SCALE_MAX:
			level.scale.x += SCALE_STEP
		if level.scale.y < SCALE_MAX:
			level.scale.y += SCALE_STEP

	if Input.is_action_pressed("ui_down"):
		if level.scale.x > SCALE_MIN:
			level.scale.x -= SCALE_STEP
		if level.scale.y > SCALE_MIN:
			level.scale.y -= SCALE_STEP

	if Input.is_action_pressed("ui_text_submit"):
		start()
		
	if started:
		var walls = level.get_children()
		for wall in walls:
			wall.position.x -= 2


func start():
	started = true
