extends Node2D

@onready var level = $Level

const SCALE_MIN = Vector2(0.3, 0.3)
const SCALE_MAX = Vector2(1, 1)
const SCALE_STEP = Vector2(0.01, 0.01)
const WALL_POSITION_STEP_MAX = 20

var wall_position_step = 10

var walls_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level.scale = SCALE_MAX


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		if level.scale < SCALE_MAX:
			level.scale += SCALE_STEP
			wall_position_step += 0.02
			wall_position_step = clamp(wall_position_step, 0, WALL_POSITION_STEP_MAX)
	elif Input.is_action_pressed("ui_down"):
		if level.scale > SCALE_MIN:
			level.scale -= SCALE_STEP
			wall_position_step -= 0.02
			wall_position_step = clamp(wall_position_step, 0, WALL_POSITION_STEP_MAX)
	else:
		wall_position_step = 4

	if Input.is_action_pressed("ui_text_submit"):
		start()
		
	if walls_moving:
		var walls = level.get_children()
		for wall in walls:
			wall.position.x -= wall_position_step


func start():
	walls_moving = true


func _on_player_collision_in_front():
	walls_moving = false


func _on_player_no_collision_in_front():
	walls_moving = true
