extends CharacterBody2D

var is_fall
var motion = Vector2()

func _physics_process(_delta):
	if is_fall == true:
		motion.y += 20
	elif is_fall == false:
		motion.y = 0
		position.y = 0
	velocity = motion
	move_and_slide()

func _on_player_entered_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("shake")

func fall():
	is_fall = true
	$playerEntered/CollisionShape2D.disabled = true
	

func _on_player_entered_body_exited(body):
	if body.is_in_group("player"):
		$Timer.wait_time = 2
		$Timer.start()


func _on_timer_timeout():
	is_fall = false
	$playerEntered/CollisionShape2D.disabled = false
	$image.frame = 0
