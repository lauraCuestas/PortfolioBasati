extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://02_scenes/05_others/main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
