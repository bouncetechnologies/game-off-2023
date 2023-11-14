extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MIN_SCALE = 1
const MAX_SCALE = 10
const SCALE_INCREMENT = 0.1

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = get_parent().get_node("Camera2D")
@onready var initial_zoom = get_parent().get_node("Camera2D").zoom

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false
var dead = false

func _ready():
	animated_sprite.play("idle")
	$AnimatedSprite2D.play_backwards("disolve")


func _physics_process(delta):
	var collider_left = $RayCastLeft.get_collider()
	var collider_right = $RayCastRight.get_collider()
	if dead and not $Death.is_playing():
		dead = false
		get_tree().reload_current_scene()

		
	elif dead:
		return
		
	if collider_left and collider_left.is_in_group("kill_wall") or collider_right and collider_right.is_in_group("kill_wall"):
		$Death.play()
		$AnimationPlayer.play("disolve")
		dead = true
	
	if position.y > 800:
		$Death.play()
		$AnimationPlayer.play("disolve")		
		dead = true
		
		

		
		
		
	
	# Handle scaling
	if Input.is_action_pressed("scale_up") and scale.x < MAX_SCALE and not $RayCastUp.is_colliding():
		scale.x = clamp(scale.x + SCALE_INCREMENT, MIN_SCALE, MAX_SCALE)
		scale.y = clamp(scale.y + SCALE_INCREMENT, MIN_SCALE, MAX_SCALE)
		camera.zoom.x = initial_zoom.x * 1.0/scale.x
		camera.zoom.y = initial_zoom.y * 1.0/scale.y
		velocity = Vector2.ZERO
		move_and_slide()
		$Scale.pitch_scale = 1.0/scale.x
		$Scale.play()
		return
	elif Input.is_action_pressed("scale_down") and scale.x > MIN_SCALE:
		scale.x = clamp(scale.x - SCALE_INCREMENT, MIN_SCALE, MAX_SCALE)
		scale.y = clamp(scale.y - SCALE_INCREMENT, MIN_SCALE, MAX_SCALE)
		camera.zoom.x = initial_zoom.x * 1.0/scale.x
		camera.zoom.y = initial_zoom.y * 1.0/scale.y
		velocity = Vector2.ZERO
		move_and_slide()
		$Scale.pitch_scale = 1.0/scale.x
		$Scale.play()
		return
	
	$Scale.stop()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * scale.y
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Handle facing sprite
	if direction == -1:
		animated_sprite.flip_h = true
	elif direction == 1:
		animated_sprite.flip_h = false

	# Handle applying forward velocity
	if direction:
		velocity.x = direction * SPEED * sqrt(scale.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle jump ascend
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * scale.y
		animated_sprite.play("jump_ascending")
		is_jumping = true
		
	# Handle jump descend
	elif velocity.y > 0:
		animated_sprite.play("jump_descending")
		
	# Handle jump land
	elif is_jumping and is_on_floor():
		animated_sprite.play("jump_land")
		is_jumping = false

	# Handle running
	elif direction and not is_jumping:
		animated_sprite.play("running")
	
	# Handle idle
	elif not is_jumping:
		if not (animated_sprite.animation == "jump_land" and animated_sprite.is_playing()):
			animated_sprite.play("idle")

	move_and_slide()
