extends CanvasLayer
class_name HUD

## Variable Declerations
@onready var health_score_label: Label = %Health_Score

var health_score = 6:
	set(new_health_score):
		health_score = new_health_score
		_update_score_label()

func _ready() -> void:
	_update_score_label()

func _update_score_label():
	health_score_label.text = str(health_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_amount_of_health(value: Variant) -> void:
	health_score = value


func _on_player_current_slam_cooldown(value: Variant) -> void:
	pass # Replace with function body.
