extends Area2D


func _on_body_entered(_body):
	game.next_level()
