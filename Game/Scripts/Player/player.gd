extends CharacterBody3D

## Variable Declarations

# Current placeholder speed variable
var CURRENT_SPEED = 5.0
# Speed for Walking
var SPEED = 5.0
# Speed for Running
var RUNNING_SPEED = 9.0
# Slows down player when attacking
var SLOW_SPEED = 3.0
# How high player jumps
var JUMP_VELOCITY = 14
# How far dash is
var DASH_SPEED = 25
# Dash cooldown
var didDash = false
# Attack cooldown
var didAttack = false
# Slam cooldown
var didSlam = false
# Dash length, turns off when dash_length timer is stopped/timeouted
var isDashing = false
# Attacking Length
var isAttacking = false
# Slamming Length
var isSlamming = false
const gravity = 40
# Stores the dash direction
var dash_direction: Vector3 = Vector3.ZERO

# This enum lists all the possible states the character can be in.
enum States {IDLE, RUNNING, JUMPING, FALLING, DASHING, WALKING, ATTACKING, SLAMMING}

# This variable keeps track of the character's current state.
var state: States = States.IDLE

# Node Declarations
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var dash_cooldown: Timer = $Dash_Cooldown # Manipulate Wait Time to increase/decrease cd
@onready var dash_length: Timer = $Dash_Length # Manipulate Wait Time to increase/decrease dash length
@onready var attack_cooldown: Timer = $Attack_Cooldown
@onready var slam_cooldown: Timer = $Slam_Cooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attacking_collision: CollisionShape3D = $Attacking_Hitbox/Attacking_Collision
@onready var slamming_collision: CollisionShape3D = $Slamming_Hitbox/Slamming_Collision

func _ready() -> void:
	attacking_collision.disabled = true
	slamming_collision.disabled = true

func _physics_process(delta: float) -> void:
	#Prevents player from going in different directions in the Z axis
	velocity.z = 0
	if position.z > 0 or position.z < 0:
		position.z = 0

	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get input direction
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Empty", "Empty")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_dir := Input.get_axis("Move_Left", "Move_Right")
	var is_initiating_sprint := Input.is_action_pressed("Sprint")
	var is_initiating_jump := Input.is_action_just_pressed("Jump")
	var is_initiating_dash := Input.is_action_just_pressed("Dash")
	var is_initiating_attack := Input.is_action_just_pressed("Attack")
	var is_initiating_slam := Input.is_action_just_pressed("Slam")

	# State Changes
	if isDashing:
		# Prevent state change during dashing
		velocity.x = dash_direction.x * DASH_SPEED
		velocity.y = 0
	else:
		if is_initiating_attack and not didAttack:
			change_state(States.ATTACKING)
		elif is_initiating_slam and not didSlam:
			change_state(States.SLAMMING)
		elif is_initiating_jump and is_on_floor():
			change_state(States.JUMPING)
		elif is_initiating_dash and not didDash and direction.x != 0:
			dash_direction = direction
			change_state(States.DASHING)
		elif not is_on_floor() and velocity.y < 0:
			change_state(States.FALLING)
		elif direction and is_initiating_sprint:
			change_state(States.RUNNING)
		elif direction and not is_initiating_sprint:
			change_state(States.WALKING)
		elif is_initiating_slam:
			change_state(States.SLAMMING)
		else:
			change_state(States.IDLE)

	# Handle movement based on state
	if state == States.WALKING:
		velocity.x = direction.x * SPEED
		CURRENT_SPEED = SPEED
	elif state == States.RUNNING:
		velocity.x = direction.x * RUNNING_SPEED
		CURRENT_SPEED = RUNNING_SPEED
	elif state == States.IDLE:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	elif state == States.ATTACKING or state == States.SLAMMING:
		velocity.x = direction.x * SLOW_SPEED
	elif state == States.JUMPING or state == States.FALLING:
		velocity.x = direction.x * CURRENT_SPEED  # Allow input to change horizontal movement
		if state == States.JUMPING:
			velocity.y += JUMP_VELOCITY

	# Flip sprite based on input direction
	_sprite_flip(current_dir)
	move_and_slide()

func change_state(new_state: States) -> void:
	#Prevents State Change if one of the Booleans are active
	if isDashing:
		return
	if isAttacking:
		return
	if isSlamming:
		return
	# Only change the state if it's different from the current one
	if state != new_state:
		state = new_state
		match state:
			States.WALKING:
				animation_player.play("Walk")
			States.RUNNING:
				animation_player.play("Run")
			States.IDLE:
				animation_player.play("Idle")
			States.JUMPING:
				pass
			States.FALLING:
				animation_player.play("Falling")
			States.DASHING:
				isDashing = true
				didDash = true
				animation_player.play("Dash")
				dash_length.start()
			States.SLAMMING:
				isSlamming = true
				didSlam = true
				animation_player.play("Slam")
				slam_cooldown.start()
			States.ATTACKING:
				isAttacking = true
				didAttack = true
				animation_player.play("Attack")
				attack_cooldown.start()

func _sprite_flip(current_dir: float = 0) -> void:
	if current_dir == 1:
		animated_sprite_3d.flip_h = false
		slamming_collision.position.x = 2.376
		attacking_collision.position.x = 2.277
	elif current_dir == -1: 
		animated_sprite_3d.flip_h = true
		slamming_collision.position.x = -2.277
		attacking_collision.position.x = -2.376

func _on_dash_cooldown_timeout() -> void:
	didDash = false

func _on_dash_length_timeout() -> void:
	isDashing = false
	velocity.x = 0
	change_state(States.FALLING)
	dash_cooldown.start()


func _on_attack_cooldown_timeout() -> void:
	didAttack = false

func _on_animated_sprite_3d_animation_finished() -> void:
	pass

func _on_slam_cooldown_timeout() -> void:
	didSlam = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	isAttacking = false
	isSlamming = false
	change_state(States.IDLE)
