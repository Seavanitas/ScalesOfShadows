extends StaticBody3D

var attack := 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tall_spikes_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body._receive_damage(attack)
