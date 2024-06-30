extends CanvasLayer

@onready var main = $"../../"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_resume_pressed():
	get_tree().paused = false
	self.hide()

func _on_quit_pressed():
	game.restart()
	get_tree().paused = false
