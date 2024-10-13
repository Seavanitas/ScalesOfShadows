extends Node3D

## Variable Declarations

# How fast the arrows move
var arrow_speed := 7.0
# How fast the arrow rotates
var arrow_rotation_speed := 15.0
# Player flag
var player_hit = false
# Timer flag
var is_reloading = false
# Attack
var attack := 1
## Arrow-specific speeds
var arrow1_speed := 7.0
var arrow2_speed := 7.0
var arrow3_speed := 7.0
var arrow4_speed := 7.0
var arrow5_speed := 7.0

## Node Declarations
@onready var arrow_1: Node3D = $Arrows/Arrow
@onready var arrow_2: Node3D = $Arrows/Arrow2
@onready var arrow_3: Node3D = $Arrows/Arrow3
@onready var arrow_4: Node3D = $Arrows/Arrow4
@onready var arrow_5: Node3D = $Arrows/Arrow5
@onready var reloading: Timer = $Reloading
@onready var lifespan: Timer = $Lifespan

@onready var arrow_spawn_1: RayCast3D = $ArrowSpawns/arrow_spawn1
@onready var arrow_spawn_2: RayCast3D = $ArrowSpawns/arrow_spawn2
@onready var arrow_spawn_3: RayCast3D = $ArrowSpawns/arrow_spawn3
@onready var arrow_spawn_4: RayCast3D = $ArrowSpawns/arrow_spawn4
@onready var arrow_spawn_5: RayCast3D = $ArrowSpawns/arrow_spawn5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow_1.position.z = arrow_spawn_1.position.z
	arrow_2.position.z = arrow_spawn_2.position.z
	arrow_3.position.z = arrow_spawn_3.position.z
	arrow_4.position.z = arrow_spawn_4.position.z
	arrow_5.position.z = arrow_spawn_5.position.z
	is_reloading = true
	reloading.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_reloading:
		arrow_1.position.z += arrow1_speed * delta
		arrow_1.rotation.z += arrow_rotation_speed * delta

		arrow_2.position.z += arrow2_speed * delta
		arrow_2.rotation.z += arrow_rotation_speed * delta

		arrow_3.position.z += arrow3_speed * delta
		arrow_3.rotation.z += arrow_rotation_speed * delta

		arrow_4.position.z += arrow4_speed * delta
		arrow_4.rotation.z += arrow_rotation_speed * delta

		arrow_5.position.z += arrow5_speed * delta
		arrow_5.rotation.z += arrow_rotation_speed * delta

	elif is_reloading:
		arrow1_speed = 0
		arrow2_speed = 0
		arrow3_speed = 0
		arrow4_speed = 0
		arrow5_speed = 0
		arrow_rotation_speed = 0

func _on_reloading_timeout() -> void:
	is_reloading = false
	arrow1_speed = 7.0
	arrow2_speed = 7.0
	arrow3_speed = 7.0
	arrow4_speed = 7.0
	arrow5_speed = 7.0
	arrow_rotation_speed = 15.0
	lifespan.start()

func _on_lifespan_timeout() -> void:
	is_reloading = true
	arrow_1.position.z = arrow_spawn_1.position.z
	arrow_2.position.z = arrow_spawn_2.position.z
	arrow_3.position.z = arrow_spawn_3.position.z
	arrow_4.position.z = arrow_spawn_4.position.z
	arrow_5.position.z = arrow_spawn_5.position.z
	reloading.start()

# Signal functions for each arrow
func _on_arrow_1_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		arrow_1.position.z = arrow_spawn_1.position.z
		arrow1_speed = 0
	if body.is_in_group("Player"):
		body._receive_damage(attack)
func _on_arrow_2_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		arrow_2.position.z = arrow_spawn_2.position.z
		arrow2_speed = 0
	if body.is_in_group("Player"):
		body._receive_damage(attack)
func _on_arrow_3_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		arrow_3.position.z = arrow_spawn_3.position.z
		arrow3_speed = 0
	if body.is_in_group("Player"):
		body._receive_damage(attack)
func _on_arrow_4_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		arrow_4.position.z = arrow_spawn_4.position.z
		arrow4_speed = 0
	if body.is_in_group("Player"):
		body._receive_damage(attack)
func _on_arrow_5_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		arrow_5.position.z = arrow_spawn_5.position.z
		arrow5_speed = 0
	if body.is_in_group("Player"):
		body._receive_damage(attack)
