extends Area2D
signal damage


func setup(pos):
	position = pos

func _on_body_entered(body):
	if body.name == "player" and body.deadPlayer == false:
		emit_signal("damage")
