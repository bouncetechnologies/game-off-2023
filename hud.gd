extends CanvasLayer

var deaths = 0
var time: float = 0.0
var msec: float = 0.0
var seconds: float = 0.0
var minutes: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func iterate_death_counter():
	deaths += 1
	$RichTextLabel.text = "Deaths: " + str(deaths)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$RichTextLabel2.text = "Time: %02d:%02d.%02d" % [minutes, seconds, msec]
