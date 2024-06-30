extends Node

func _ready():
	var level = load(game.levels[game.current_level]).instantiate()
	add_child(level)
