extends Control

@onready var level_1: Button = $VBoxContainer/Level_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_1.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Dungeon/level_3.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Dungeon/level_2.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Dungeon/level_1.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Overworld/tutorial.tscn")
