extends Node2D

@onready var pause_menu = $pause_menu
var collectible_scn = preload("res://02_scenes/02_objects/collectibles.tscn")
var score
var checkpoint
var obstacle_tscn = preload("res://02_scenes/02_objects/obstaculos.tscn")

signal recieveDamage
signal cats_changed
signal coins_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	$pickupItems.hide()
	$player.start($playerStart.position)
	game.last_position = ($playerStart.position)
	score = 0
	spawn_items()
	spawn_obstacles()

func _enter_tree():
	if game.last_position:
		$player.global_position = game.last_position

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()

func spawn_items():
	for cell in $pickupItems.get_used_cells(0):
		var data = $pickupItems.get_cell_tile_data(0, cell)
		var type = data.get_custom_data("type")
		var texture = data.get_custom_data("texture")
		
		if type in ['gato', 'coin']:
			var item = collectible_scn.instantiate()
			var pos = $pickupItems.map_to_local(cell)
			item.setup(type, pos, texture)
			if type == "gato":
				item.connect("pickupCat",_on_cat_pickup)
			if type == "coin":
				item.connect("pickupCoin",_on_coin_pickup)
			add_child(item)

func spawn_obstacles():
	for cell in $obstacles.get_used_cells(0):
		var obstacle = obstacle_tscn.instantiate()
		var posObs = $obstacles.map_to_local(cell)
		obstacle.setup(posObs)
		obstacle.connect("damage",damagePlayer)
		add_child(obstacle)

func _on_cat_pickup():
	game.cats += 1
	emit_signal("cats_changed") 

func _on_coin_pickup():
	game.coins += 1 
	emit_signal("coins_changed")
	
func damagePlayer():
	$player.dead()
