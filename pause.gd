extends Control

var _is_paused: bool = false:
	set = set_paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_paused(value: bool):
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_button_pressed():
	_is_paused = false

func _unhandled_input(event):
	if event.is_action_pressed("paused"):
		_is_paused = !_is_paused
