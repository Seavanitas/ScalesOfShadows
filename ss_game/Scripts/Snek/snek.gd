extends CharacterBody3D

## Variable Declerations

var health := 2
var current_dir := -1
var knockback := 10
var knockback_airtime := 15
var knockback_dir := 0
var is_knocked_back = false
const SPEED = 1.5
const JUMP_VELOCITY = 4.5
const gravity = 40
var attack := 1 # attack dmg
var enemy_dir := 1
@onready var left_floor: RayCast3D = $RayCastNodes/Left_floor
@onready var right_floor: RayCast3D = $RayCastNodes/right_floor
@onready var left_wall: RayCast3D = $RayCastNodes/Left_wall
@onready var right_wall: RayCast3D = $RayCastNodes/right_wall
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var knockback_delay: Timer = $Knockback_delay
@onready var snek_collision: CollisionShape3D = $Snek_attack_hitbox/Snek_collision

func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()

	# Prevents object from going in different directions in the Z axis
	velocity.z = 0
	if position.z > 0 or position.z < 0:
		position.z = 0

	# Gravity
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	# knockback
	if is_knocked_back:
		velocity.x = move_toward(velocity.x, 0, knockback * delta)
		if abs(velocity.x) < 0.1:
			velocity.x = 0
			is_knocked_back = false

	# Movement
	position.x += current_dir * SPEED * delta
	_handle_direction()
	_sprite_flip()
	move_and_slide()

func _sprite_flip():
	if current_dir == 1:
		animated_sprite_3d.flip_h = true
		snek_collision.position.x = 1
		enemy_dir = 1
	elif current_dir == -1:
		animated_sprite_3d.flip_h = false
		snek_collision.position.x = -1
		enemy_dir = -1
func _handle_direction():
	if !left_floor.is_colliding():
		current_dir = 1
	elif !right_floor.is_colliding():
		current_dir = -1
	elif left_wall.is_colliding():
		current_dir = 1
	elif right_wall.is_colliding():
		current_dir = -1

func _receive_knockback_dir(player_dir) -> void:
	knockback_dir = player_dir
	print(knockback_dir)

func _receive_damage(player_dmg) -> void:
	health -= player_dmg

func _on_snek_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_attack"):
		knockback_delay.start()
		animated_sprite_3d.modulate = Color(1,0,0,)
	elif area.is_in_group("player_slam"):
		knockback_delay.start()
		animated_sprite_3d.modulate = Color(1,0,0,)
func _on_knockback_delay_timeout() -> void:
	velocity.x = knockback * knockback_dir
	velocity.y = knockback_airtime
	is_knocked_back = true
	animated_sprite_3d.modulate = Color(1,1,1)

func _on_snek_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body._receive_damage(attack)
		body._recieve_enemy_dir(enemy_dir)
