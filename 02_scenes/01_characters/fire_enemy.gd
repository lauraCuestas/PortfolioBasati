extends CharacterBody2D

@onready var animationplatform = $animation

func _ready():
	$animation.play("atack")


func _on_enemy_body_body_entered(body):
	if body.get_name() == "player" and body.deadPlayer == false:
		body.dead()
		pass
