extends RayCast2D

var new_sun = preload("res://sun-2.png")
var new_bg = preload("res://bg-2.png")
var new_cloud_black = preload("res://clouds_black-2.png")
var new_cloud_white = preload("res://clouds_white-2.png")
var new_lightning = preload("res://lightning-2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if self.is_colliding() and self.get_collider().name == "Player":
		var pl = get_parent().get_node("ParallaxBackground").get_node("ParallaxLayer7")
		var pl_cloud_black = get_parent().get_node("ParallaxBackground").get_node("ParallaxLayer6")
		var pl_cloud_white = get_parent().get_node("ParallaxBackground").get_node("ParallaxLayer5")
		var pl_lightning = get_parent().get_node("ParallaxBackground").get_node("ParallaxLayer4")
		
		pl.get_node("Bg").texture = new_bg
		pl.get_node("Sun").texture = new_sun
		pl_cloud_black.get_node("CloudsBlack").texture = new_cloud_black
		pl_cloud_white.get_node("CloudsWhite").texture = new_cloud_white
		pl_lightning.get_node("Lightning").texture = new_lightning
	
