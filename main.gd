extends Node2D

var wall_should_move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	if wall_should_move:
		$MovingWall.position.x += delta * 100


func _on_timer_timeout():
	wall_should_move = true