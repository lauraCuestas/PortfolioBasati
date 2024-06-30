extends Node

var last_position = null
var num_levels = 0
var current_level = 0
var cats = 0
var coins = 0
var deaths = 0

var game_scene = "res://02_scenes/05_others/main.tscn"
var title_screen = "res://02_scenes/04_screens/menu_principal.tscn"

var levels = [
	"res://02_scenes/04_screens/cinematica_inicial.tscn",
	"res://02_scenes/03_levels/level_00.tscn",
	"res://02_scenes/03_levels/level_01.tscn",
	"res://02_scenes/03_levels/level_02.tscn",
	"res://02_scenes/03_levels/level_03.tscn",
	"res://02_scenes/04_screens/menu_victoria.tscn"
]

func _ready():
	num_levels = len(levels)
	
func restart():
	current_level = 0
	cats = 0
	coins = 0
	deaths = 0
	get_tree().change_scene_to_file(title_screen)

func next_level():
	current_level += 1
	print(current_level)
	if current_level <= num_levels:
		get_tree().change_scene_to_file(game_scene)
