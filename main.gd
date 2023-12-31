extends Node2D

var wall_should_move = false
var wall_speed = 175

# Called when the node enters the scene tree for the first time.
func _ready():
	#$ParallaxBackground.scale = $Player.scale
	var scale_factor = $Player.get_node("Camera2D").zoom.x
	var new_scale = 4/scale_factor
	$ParallaxBackground.scale = Vector2(new_scale, new_scale)
	$"/root/Hud".visible = true
	$"/root/Hud".end = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$ParallaxBackground.scale = $Player.scale
	pass


func _physics_process(delta):
	if wall_should_move and not $Player.dead:
		print("moving")
		$MovingWall.position.x += delta * wall_speed
	
	if $Player.dead:
		wall_should_move = false
		#$Camera2D.position = $Player.respawn
		$MovingWall.position.x = $Player.respawn.x - 1000
		$Timer.start()
		

func _on_timer_timeout():
	print("done")
	wall_should_move = true
