extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		game.last_position = global_position
		if body.gatoEnMano > 0:
			body.guardarGato()
