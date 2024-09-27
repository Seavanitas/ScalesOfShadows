extends Control

func _ready() -> void:
	hide()

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		show()
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()
		hide()
func _on_continue_pressed() -> void:
	resume()
	hide()

func _on_restart_pressed() -> void:
	resume()
	hide()
	get_tree().reload_current_scene()


func _on_levels_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	testEsc()


func _on_texture_button_pressed() -> void:
	show()
	pause()
