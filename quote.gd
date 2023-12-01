extends CanvasLayer

@onready var initial_scene = preload("res://Tutorial.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_packed(initial_scene)


func _on_timer_2_timeout():
	$MarginContainer/VBoxContainer/MarginContainer/Label2.label_settings.font_color = Color.WHITE
