extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var offset_x = 0
@export var offset_x_add = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var _offset = motion_offset.x + offset_x_add
	set_motion_offset(Vector2(_offset, 0))

