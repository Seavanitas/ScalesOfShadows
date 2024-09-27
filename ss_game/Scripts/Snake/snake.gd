extends CharacterBody3D

## Variable Declarations
const gravity = 40
var is_knocked_back := false

var IDLE_SPEED := 1.5
var CHASE_SPEED := 3
var current_dir := 1
var health := 4
var player = null # A variable for the player. If the player is in then player = body
var player_current_dir # A variable to store the player's current position in the scene
var attack := 2
var isAttacking = false # A boolean var to prevent the snake from spamming attacks
var enemy_dir := 1
var knockback := 5
var knockback_airtime := 15
var knockback_dir := 0

# This enum lists all the possible states the character can be in.
enum States {IDLE, CHASING, ATTACKING, DEAD}

# This variable keeps track of the character's current state.
var state: States = States.IDLE

## Node Declarations
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var floor_cast_right: RayCast3D = $RayCastNodes/FloorCastRight
@onready var floor_cast_left: RayCast3D = $RayCastNodes/FloorCastLeft
@onready var wall_cast_left: RayCast3D = $RayCastNodes/WallCastLeft
@onready var wall_cast_right: RayCast3D = $RayCastNodes/WallCastRight
@onready var enemy_sight_collider: Area3D = $EnemySightCollider
@onready var attack_cd: Timer = $AttackCD
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var strike_collider: CollisionShape3D = $strike_hitbox/strike_collider
@onready var knockback_delay: Timer = $knockback_delay

func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
		
	# Prevents enemy from going in different directions in the Z axis
	velocity.z = 0
	if position.z > 0 or position.z < 0:
		position.z = 0

	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle knockback deceleration
	if is_knocked_back:
		# Slow down the knockback velocity
		velocity.x = move_toward(velocity.x, 0, knockback * delta)
		if abs(velocity.x) < 0.1:  # Threshold to stop knockback
			velocity.x = 0
			is_knocked_back = false
			change_state(States.IDLE)  # Change back to IDLE after knockback

	# State functions based on state change
	if state == States.IDLE:
		movement()
		position.x += current_dir * IDLE_SPEED * delta
	elif state == States.CHASING:
		chase_movement(delta)
	elif state == States.ATTACKING:
		pass
	elif state == States.DEAD:
		pass

	# Flip sprite based on input direction
	_sprite_flip()
	move_and_slide()


func change_state(new_state: States) -> void:
	if state != new_state:
		state = new_state
		match state:
			States.IDLE:
				animation_player.play("Walk")
			States.CHASING:
				animation_player.play("Chase")
			States.ATTACKING:
				animation_player.play("Attack")
			States.DEAD:
				animated_sprite_3d.play("Dead")

func chase_movement(delta) -> void:
	player_current_dir = player.position.x - position.x
	current_dir = sign(player_current_dir)
	if abs(player_current_dir) > 3: # Prevents enemy from clipping in player
		position.x += current_dir * CHASE_SPEED * delta
	if not isAttacking and abs(player_current_dir) <= 4: # Changes State to ATTACKING if enemy is near/inside player
		change_state(States.ATTACKING)
		isAttacking = true
		attack_cd.start()

func movement() -> void:
	if wall_cast_left.is_colliding():
		current_dir = 1
	elif wall_cast_right.is_colliding():
		current_dir = -1
	if not floor_cast_left.is_colliding():
		current_dir = 1
	elif not floor_cast_right.is_colliding():
		current_dir = -1

func _sprite_flip() -> void:
	if current_dir == 1:
		animated_sprite_3d.flip_h = true
		strike_collider.position.x = 2
		enemy_dir = 1
	elif current_dir == -1: 
		animated_sprite_3d.flip_h = false
		strike_collider.position.x = -2
		enemy_dir = -1

func _on_enemy_sight_collider_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = body
		change_state(States.CHASING)

func _on_enemy_sight_collider_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = null
		change_state(States.IDLE)

func _on_animated_sprite_3d_animation_finished() -> void:
	if player != null:
		change_state(States.CHASING)
	else:
		change_state(States.IDLE)

func _on_attack_cd_timeout() -> void:
	isAttacking = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if player != null:
		change_state(States.CHASING)
	else:
		change_state(States.IDLE)

func _on_strike_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body._receive_damage(attack)
		body._recieve_enemy_dir(enemy_dir)

func _on_snake_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_attack"):
		knockback_delay.start()
		animated_sprite_3d.modulate = Color(1,0,0,)
	elif area.is_in_group("player_slam"):
		knockback_delay.start()
		animated_sprite_3d.modulate = Color(1,0,0,)

func _on_knockback_delay_timeout() -> void:
	velocity.x = knockback * knockback_dir
	velocity.y = knockback_airtime
	animated_sprite_3d.modulate = Color(1,1,1)
	is_knocked_back = true

func _receive_knockback_dir(player_dir) -> void:
	knockback_dir = player_dir

func _receive_damage(player_dmg) -> void:
	health -= player_dmg
