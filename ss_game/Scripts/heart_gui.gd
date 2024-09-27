extends Panel

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func update(heart_type: String):
	if heart_type == "full":
		sprite_2d.frame = 0  # Full heart frame
	elif heart_type == "half":
		sprite_2d.frame = 1  # Half heart frame
	else:
		sprite_2d.frame = 2  # Empty heart frame
