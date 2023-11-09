extends CharacterBody2D

#signal movement(velocity_x)

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
var velocity_x = 0
var started = false

var base_x_position = null

func _ready():
	base_x_position = self.position.x

func _physics_process(delta):
	print(base_x_position, self.position.x)
	

		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -(jump_velocity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
##		velocity.x = direction * SPEED
#		velocity_x = direction * SPEED
#	else:
##		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity_x = move_toward(velocity.x, 0, SPEED)
#
#	movement.emit(velocity_x)
	if base_x_position > self.position.x:
		velocity.x = SPEED / 2
	else:
		velocity.x = 0

	move_and_slide()


func _process(delta):
#	if Input.is_action_pressed("ui_right"):
#		_animated_sprite.flip_h = false
#		_animated_sprite.play("default")
#	elif Input.is_action_pressed("ui_left"):
#		_animated_sprite.flip_h = true
#		_animated_sprite.play("default")
#	else :
#		_animated_sprite.stop()
		
	if Input.is_action_pressed("ui_text_submit"):
		start()
		
	if started:
		_animated_sprite.play("default")

func start():
	started = true
		
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
 
