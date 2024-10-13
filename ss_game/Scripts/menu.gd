extends Control

@onready var start: Button = $VBoxContainer/Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Overworld/tutorial.tscn")


func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
