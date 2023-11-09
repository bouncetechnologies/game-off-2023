extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _animated_sprite = $AnimatedSprite2D


const SCALE_MIN = 1
const SCALE_MAX = 5
const SCALE_STEP = 0.1

const JUMP_MIN = 400
const JUMP_MAX = 800
const JUMP_STEP = 10


var jump_velocity = JUMP_MIN


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -(jump_velocity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		_animated_sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(delta):
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		_animated_sprite.play("default")
	else :
		_animated_sprite.stop()
		
#	if Input.is_action_pressed("ui_up"):
#		if self.scale.x < SCALE_MAX:
#			self.scale.x += SCALE_STEP
#		if self.scale.y < SCALE_MAX:
#			self.scale.y += SCALE_STEP
#		if jump_velocity < JUMP_MAX:
#			jump_velocity += JUMP_STEP
#	if Input.is_action_pressed("ui_down"):
#		if self.scale.x > SCALE_MIN:
#			self.scale.x -= SCALE_STEP
#		if self.scale.y > SCALE_MIN:
#			self.scale.y -= SCALE_STEP
#		if jump_velocity > JUMP_MIN:
#			jump_velocity -= JUMP_STEP
 
