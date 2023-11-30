extends Node2D

var wall_should_move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ParallaxBackground.scale = $Player.scale


func _physics_process(delta):
	if wall_should_move and not $Player.dead:
		$MovingWall.position.x += delta * 100
	
	if $Player.dead:
		wall_should_move = false
		#$Camera2D.position = $Player.respawn
		$MovingWall.position.x = $Player.respawn.x - 200
		$Timer.start()
		


func _on_timer_timeout():
	wall_should_move = false
