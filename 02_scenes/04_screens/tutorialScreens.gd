extends CanvasLayer

@export var level:int
var screensCount = 0

var screens = {
	0: "res://01_assets/01_sprites/BST_uiux_tutorial00.png",
	1: "res://01_assets/01_sprites/BST_uiux_tutorial01.png",
	2: "res://01_assets/01_sprites/BST_uiux_tutorial02.png"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	if level == 0:
		$image.texture = load(screens[0])
	if level == 1:
		$image.texture = load(screens[2])
	get_input()

func _physics_process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("dash"):
		if screensCount == 1 or level == 1:
			get_tree().paused = false
			queue_free()
		if level == 0:
			screensCount += 1
			$image.texture = load(screens[1])
