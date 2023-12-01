extends Node2D

@onready var data = get_node("/root/Data")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Hud".visible = false
	$"/root/Hud".end = true

func _input(event):
	if event.is_action_pressed("open_link"):
		var time = "%02d minutes, %02d seconds and %02d msec" % [data.minutes, data.seconds, data.msec]
		var message = "I died {deaths} times and completed within {time} playing https://bouncetechnologies.itch.io/game-off-2023\n#githubgameoff".format(
			{
				"deaths": data.deaths, 
				"time": time
			}
		)
		var message_encoded = message.uri_encode()
		var url = "https://twitter.com/intent/tweet?text=" + message_encoded
		OS.shell_open(url)
