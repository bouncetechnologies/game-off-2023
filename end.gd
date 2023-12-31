extends Node2D

@onready var data = get_node("/root/Data")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Hud".visible = false
	$"/root/Hud".end = true
	#$CanvasLayer/Label2.text = "Your time was: %02d:%02d.%02d" % [data.minutes, data.seconds, data.msec]
	#$CanvasLayer/Label3.text = "You died %i times" % [data.deaths]
	$CanvasLayer/Label2.text = "Your time was: %02d:%02d.%02d" % [data.minutes, data.seconds, data.msec]
	$CanvasLayer/Label3.text = "You died {deaths} times".format({"deaths": data.deaths})

func _on_button_pressed():
	var time = "%02d minutes, %02d seconds and %02d msec" % [data.minutes, data.seconds, data.msec]
	var message = "☠️ Death: {deaths}\n⌚️ Finish time: {time}\n\nhttps://bouncetechnologies.itch.io/game-off-2023\n#githubgameoff #IndieGame #GameDev #GameJam #NORT @github".format(
		{
			"deaths": data.deaths, 
			"time": time
		}
	)
	var message_encoded = message.uri_encode()
	var url = "https://twitter.com/intent/tweet?text=" + message_encoded
	OS.shell_open(url)


func _on_button_2_pressed():
	$"/root/Data".deaths = 0
	$"/root/Data".time = 0
	$"/root/Data".minutes = 0
	$"/root/Data".seconds = 0
	$"/root/Data".msec = 0
	
	get_tree().change_scene_to_file("res://main_menu.tscn")
