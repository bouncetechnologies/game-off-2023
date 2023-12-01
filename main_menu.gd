extends CanvasLayer

@onready var initial_scene = preload("res://quote.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Hud".visible = false
	$"/root/Hud".end = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(initial_scene)
