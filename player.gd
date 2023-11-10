extends CharacterBody2D

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _animated_sprite = $AnimatedSprite2D

var jump_velocity = 400
var started = false
var base_x_position = null

func _ready():
	base_x_position = self.position.x


func _physics_process(delta):	
	if position.y > 650:
		get_tree().paused = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -(jump_velocity)

	if base_x_position > self.position.x:
		velocity.x = SPEED / 2
	else:
		velocity.x = 0

	move_and_slide()


func _process(delta):
	if Input.is_action_pressed("ui_text_submit"):
		start()
		
	if started:
		_animated_sprite.play("default")


func start():
	started = true
