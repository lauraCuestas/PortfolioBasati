extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoStreamPlayer.play()

func _on_video_stream_player_finished():
	game.next_level()


func _on_button_pressed():
	game.next_level()
