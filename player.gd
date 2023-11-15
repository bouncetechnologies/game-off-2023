extends CharacterBody2D

signal died

@export var SPEED = 300.0
@export var SPEED_UP_INTERVAL = 50
@export var SPEED_DOWN_INTERVAL = 30
@export var SPEED_DOWN_INTERVAL_AIRBORNE = 7
@export var SPEED_WALL_SLIDE = 35.0
@export var SPEED_TERMINAL_VELOCITY = 300.0
@export var JUMP_VELOCITY = -400.0
@export var MIN_SCALE = 1
@export var MAX_SCALE = 10
@export var SCALE_INCREMENT = 0.1

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = get_parent().get_node("Camera2D")
@onready var initial_zoom = get_parent().get_node("Camera2D").zoom

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false
var dead = false

func _ready():
	animated_sprite.play("idle")
	$AnimationPlayer.play_backwards("disolve")
	$Life.play()

func _process(delta):
	var player_frame = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation,$AnimatedSprite2D.get_frame())
	$GPUParticles2D.texture = player_frame
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction == -1:
		$GPUParticles2D.process_material.set("scale_min", -scale.x)
		$GPUParticles2D.process_material.set("scale_max", -scale.x)
		
	elif direction == 1:
		$GPUParticles2D.process_material.set("scale_min", scale.x)
		$GPUParticles2D.process_material.set("scale_max", scale.x)

func _physics_process(delta):
	# Handle respawn
	if dead and not $Death.is_playing():
		dead = false
		get_tree().reload_current_scene()
	elif dead:
		$GPUParticles2D.emitting = false
		return
		
	$GPUParticles2D.emitting = true
	
	# Handle death conditions
	var collider_left = $RayCastLeft.get_collider()
	var collider_right = $RayCastRight.get_collider()
	
	if collider_left and collider_left.is_in_group("kill_wall") or collider_right and collider_right.is_in_group("kill_wall"):
		$Death.play()
		$AnimationPlayer.play("disolve")
		dead = true
		died.emit()
	
	if position.y > 800:
		$Death.play()
		$AnimationPlayer.play("disolve")
		dead = true
		died.emit()
	
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
	else:
		$Scale.stop()
	
	# Add the gravity.
	if not is_on_floor():
		var new_velocity_y = velocity.y + (gravity * delta * scale.y)
		velocity.y = clamp(new_velocity_y, -INF, SPEED_TERMINAL_VELOCITY)
	
	# Apply wall slide gravity modifier
	if is_on_wall_only() and velocity.y >= 0:
		velocity.y = SPEED_WALL_SLIDE
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Handle facing sprite
	if direction == -1:
		animated_sprite.flip_h = true
		#$GPUParticles2D.flip_h = true
	elif direction == 1:
		animated_sprite.flip_h = false
		#$GPUParticles2D.flip_h = false
		

	# Handle applying forward velocity
	if direction:
		var new_velocity_x = direction * SPEED * sqrt(scale.x)
		velocity.x = move_toward(velocity.x, new_velocity_x, SPEED_UP_INTERVAL)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED_DOWN_INTERVAL)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED_DOWN_INTERVAL_AIRBORNE)

	# Handle jump ascend
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * scale.y
		animated_sprite.play("jump_ascending")
		is_jumping = true
	
	# Handle wall slide
	elif is_on_wall_only():
		if animated_sprite.animation != "wall_slide" and not animated_sprite.is_playing():
			animated_sprite.play("wall_slide")
	
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
			$GPUParticles2D.emitting = false
			

	move_and_slide()
