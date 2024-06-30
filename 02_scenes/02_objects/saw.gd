extends Node2D


@onready var animationplatform=$animation

func _ready():
	$animation.play("rotation")


func _on_area_2d_body_entered(body):
	if body.get_name() == "player" and body.deadPlayer == false:
		body.dead()
		pass
