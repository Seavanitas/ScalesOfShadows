extends HBoxContainer

@onready var HeartGUIClass = preload("res://Prefabs/HUD/heart_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGUIClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	# Assuming max health is 6 (3 hearts)
	var hearts = get_children()
	var full_hearts = currentHealth / 2   # Each full heart represents 2 health
	var half_heart = currentHealth % 2    # Remainder to determine if we need a half-heart

	# Update the heart GUI
	for i in range(hearts.size()):
		if i < full_hearts:
			hearts[i].update("full")  # Full heart
		elif i == full_hearts and half_heart > 0:
			hearts[i].update("half")  # Half heart
		else:
			hearts[i].update("empty") # Empty heart
