extends CanvasLayer

# Called when the node enters the scene tree for the first time.
@onready var data = get_node("/root/Data")
var end = false

func _ready():
	pass # Replace with function body.

func iterate_death_counter():
	data.deaths += 1
	$RichTextLabel.text = "Deaths: " + str(data.deaths)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not end:
		data.time += delta
		data.msec = fmod(data.time, 1) * 100
		data.seconds = fmod(data.time, 60)
		data.minutes = fmod(data.time, 3600) / 60
		$RichTextLabel2.text = "Time: %02d:%02d.%02d" % [data.minutes, data.seconds, data.msec]
