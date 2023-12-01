extends RayCast2D

@export var wall_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if self.is_colliding() and self.get_collider().name == "Player":
		get_parent().wall_speed = wall_speed
