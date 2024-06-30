extends PathFollow2D

@onready var animationplatform=$animation

func _ready():
	animationplatform.play("moving")
pass

