extends RayCast2D

@export var next_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
"res://Level 3.tscn"
func _physics_process(delta):
	if self.is_colliding() and self.get_collider().name == "Player":
		print("Yay")
		get_tree().change_scene_to_packed(next_scene)
		
