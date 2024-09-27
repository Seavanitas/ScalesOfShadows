extends Area3D

@onready var label_3d_6: Label3D = $Label3D6
var player_in_area: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_3d_6.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("Interact"):
		get_tree().change_scene_to_file("res://Scenes/win.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_in_area = true
		label_3d_6.show()

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_in_area = false
		label_3d_6.hide()
