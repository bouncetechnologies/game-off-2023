extends CharacterBody2D

signal died

@export var SPEED = 300.0
@export var SPEED_UP_INTERVAL = 50
@export var SPEED_DOWN_INTERVAL = 30
@export var SPEED_DOWN_INTERVAL_AIRBORNE = 7
@export var SPEED_WALL_SLIDE_DESCEND = 35.0
@export var SPEED_TERMINAL_VELOCITY = 300.0
@export var JUMP_VELOCITY = -400.0
@export var JUMP_CUT_VELOCITY = -50.0
@export var JUMP_VELOCITY_WALL_SLIDE = -300.0
@export var JUMP_VELOCITY_WALL_SLIDE_X = -400
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
var facing_direction = 1
var last_wall_touched = 1

func _ready():
	animated_sprite.play("idle")
	$AnimationPlayer.play_backwards("disolve")
	$Life.play()

func _process(delta):
	$GPUParticles2D.process_material.set("scale_min", scale.x)
	$GPUParticles2D.process_material.set("scale_max", scale.x)
	
	var player_frame
	
	if animated_sprite.flip_h:
		player_frame = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation + "_flipped",$AnimatedSprite2D.get_frame())
	elif not animated_sprite.flip_h:
		player_frame = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation,$AnimatedSprite2D.get_frame())
	
	$GPUParticles2D.texture = player_frame

func _physics_process(delta):
	
	# Handle respawn
	if dead and not $Death.is_playing():
		dead = false
		get_tree().reload_current_scene()
	elif dead:
		$GPUParticles2D.emitting = false
		return
	
	if not $Life.is_playing():
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
		velocity.y = clamp(new_velocity_y, -INF, SPEED_TERMINAL_VELOCITY * scale.y)
	
	# Apply wall slide gravity modifier
	if is_on_wall_only() and velocity.y >= 0:
		velocity.y = SPEED_WALL_SLIDE_DESCEND * sqrt(scale.y)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Handle facing sprite
	if direction == -1:
		animated_sprite.flip_h = true
		$GPUParticles2D.process_material.set("emission_shape_offset", Vector3(1.5, 0, 0))
		
		# Store the facing direction so we know which direction to apply
		# velocty for wall jumps
		facing_direction = direction
	elif direction == 1:
		animated_sprite.flip_h = false
		$GPUParticles2D.process_material.set("emission_shape_offset", Vector3(-1.5, 0, 0))
		
		facing_direction = direction

	# Handle applying horizontal velocity
	if direction:
		# We have an input direction, speed the player character up
		var new_velocity_x = direction * SPEED * sqrt(scale.x)
		if not is_on_wall_only() and $JustWallJumpedTimer.time_left == 0:
			# Not on wall, and not recently wall jumped, so speed up normally.
			velocity.x = move_toward(velocity.x, new_velocity_x, SPEED_UP_INTERVAL)
		elif is_on_wall_only() and direction != last_wall_touched:
			# We're on a wall, and we're moving away from it.
			animated_sprite.play("jump_descending")
			velocity.x = move_toward(velocity.x, new_velocity_x, SPEED_UP_INTERVAL)
		elif not is_on_wall_only() and $JustWallJumpedTimer.time_left != 0 and direction == last_wall_touched:
			# We've recently jumped off a wall, and we're trying to get back to the wall.
			# Therefore we slowly give them back control of the direction so they can't
			# get back to the wall at a higher point than where they jumped off.
			var factor = pow((1 - $JustWallJumpedTimer.time_left), 2.0)
			new_velocity_x = direction * -JUMP_VELOCITY_WALL_SLIDE_X * factor * sqrt(scale.x)
			velocity.x = move_toward(velocity.x, new_velocity_x, SPEED_UP_INTERVAL)
		elif not is_on_wall_only() and $JustWallJumpedTimer.time_left != 0 and direction != last_wall_touched:
			# We've recently jumped off a wall, and we're trying to move away from the wall.
			# We therefore conserve the velocity from the wall jump without altering it.
			pass

	else:
		# No input direction, slow the player character down
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED_DOWN_INTERVAL)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED_DOWN_INTERVAL_AIRBORNE)

	# Handle jump ascend
	#if Input.is_action_pressed("jump") and velocity.y > JUMP_VELOCITY:
		#velocity.y += JUMP_VELOCITY_INCREMENT * sqrt(scale.y)
		#if animated_sprite.animation != "jump_ascending":
			#animated_sprite.play("jump_ascending")
		#is_jumping = true
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * scale.y
		animated_sprite.play("jump_ascending")
		is_jumping = true
	elif Input.is_action_just_released("jump"):
		if velocity.y < JUMP_CUT_VELOCITY:
			velocity.y = JUMP_CUT_VELOCITY
		
	# Handle wall slide and jump on left wall
	elif not is_on_floor() and $RayCastWallJumpLeft.is_colliding():
		last_wall_touched = -1
		
		#animated_sprite.flip_h = true
		if animated_sprite.animation != "wall_slide" and not animated_sprite.is_playing():
			animated_sprite.play("wall_slide")
		
		# Handle wall jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY_WALL_SLIDE * sqrt(scale.y)
			velocity.x = -JUMP_VELOCITY_WALL_SLIDE_X * sqrt(scale.x)
			animated_sprite.flip_h = false
			animated_sprite.play("jump_ascending")
			is_jumping = true
			$JustWallJumpedTimer.start()
		
	# Handle wall slide and jump on right wall
	elif not is_on_floor() and $RayCastWallJumpRight.is_colliding():
		last_wall_touched = 1
		
		#animated_sprite.flip_h = false
		if animated_sprite.animation != "wall_slide" and not animated_sprite.is_playing():
			animated_sprite.play("wall_slide")
		
		# Handle wall jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY_WALL_SLIDE * sqrt(scale.y)
			velocity.x = JUMP_VELOCITY_WALL_SLIDE_X * sqrt(scale.x)
			animated_sprite.flip_h = true
			animated_sprite.play("jump_ascending")
			is_jumping = true
			$JustWallJumpedTimer.start()
	
	# Handle jump max
	elif not is_on_floor() and ( velocity.y >= -100 && velocity.y < 100 ):
		animated_sprite.play("jump_max")
	
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
