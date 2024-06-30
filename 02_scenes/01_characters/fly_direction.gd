extends PathFollow2D

@onready var animationplatform=$enemyBody/animation

func _ready():
	animationplatform.play("fly")



func _on_enemy_body_body_entered(body):
	if body.get_name() == "player" and body.deadPlayer == false:
		body.dead()
		pass
