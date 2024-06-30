extends CharacterBody2D

@export var speed = 200
@export var gravity = 980

var facing = 1

func _physics_process(delta):
	
	velocity.y += gravity * delta
	velocity.x = facing * speed
	
	$image.flip_h = velocity.x > 0
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = -100
	
	if (is_on_floor() and !$RayCast2D.is_colliding()):
		facing = facing * -1
		velocity.y = -100

	if position.y > 10000:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and body.deadPlayer == false:
		body.dead()
