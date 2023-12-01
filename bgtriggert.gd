extends RayCast2D

var new_sun = preload("res://sun-2.png")
var new_bg = preload("res://bg-2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if self.is_colliding() and self.get_collider().name == "Player":
		var pl = get_parent().get_node("ParallaxBackground").get_node("ParallaxLayer7")
		pl.get_node("Bg").texture = new_bg
		pl.get_node("Sun").texture = new_sun
