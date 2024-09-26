@tool
extends StaticBody3D

## Variable Declerations

# How fast the arrows move
var arrow_speed := 5
# How fast the arrow rotates
var arrow_rotation_speed := 10
# Player flag
var player_hit = false
# Timer flag
var is_reloading = false

## Node Declerations
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
	is_reloading = true
	reloading.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_reloading == false:
		arrow_1.position.z += arrow_speed * delta
		arrow_1.rotation.z += arrow_rotation_speed * delta
	elif is_reloading == true:
		arrow_speed = 0
		arrow_rotation_speed = 0

func _on_reloading_timeout() -> void:
	is_reloading = false
	lifespan.start()


func _on_lifespan_timeout() -> void:
	is_reloading = true
	arrow_1.position.z = arrow_spawn_1.position.z
	arrow_2.position.z = arrow_spawn_2.position.z
	arrow_3.position.z = arrow_spawn_3.position.z
	arrow_4.position.z = arrow_spawn_4.position.z
	arrow_5.position.z = arrow_spawn_5.position.z
	reloading.start()
