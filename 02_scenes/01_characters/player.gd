extends CharacterBody2D

enum {IDLE, RUN, JUMP, DEAD, DASH}
var state
var anim
var new_anim
var dash_direction: Vector2
var can_dash:bool = true
var is_dashing:bool = false
var vectDash: Vector2
var dotProduct 
var orbes
var player_pos
var orbes_en_rango: Array
var orbe_normalized
var dotProduct_final
var nearest_orbe
var jump_dash:bool = false
var animationDash = false
var deadPlayer = false
var deadDashingPlayer = false
var timerOrbe = false
var normal: Vector2
var offset: float
var deadPlayerMovement:bool = false

var mouse_normalized: Vector2
var orbeADashear
var VectDashFunc
var dashDirFunc
var orbeFinalNormalizedFunc: Vector2
var mouseNormalizedFunc
var dotProductFinalFunc

var gatoEnMano
var gato

@export var run_speed:int
@export var jump_speed:int
@export var gravity:int
@export var life:int
@export var limit:int

@export var dash_speed:float
@export var dash_length:float


@onready var dash_timer: Timer = get_node("dashTimer")
@onready var dash_animationTimer: Timer = get_node("dashAnimationTimer")
@onready var walkParticles = $walkParticles
@onready var audio = $audio

#coyote time
var _airtime: float = 0.0
var _jumps: int = 0

var audios = {
	"hit": "res://01_assets/03_sound/01_sfx/Hit.wav",
	"jump": "res://01_assets/03_sound/01_sfx/Jump02.wav",
	"doubleJump": "res://01_assets/03_sound/01_sfx/Jump.wav",
	"jumpLand": "res://01_assets/03_sound/01_sfx/JumpLand.wav"
}

signal life_changed
signal death
signal gatoPerdido

func _ready():
	change_state(IDLE)
	gatoEnMano = 0

func _physics_process(delta):
	velocity.y += gravity * delta
	
	_airtime += delta
	
	get_input()
	handle_dash()
	
	if deadPlayerMovement == false:
		move_and_slide()
	
	if position.x < limit:
		position.x = limit
	
	var arrow_rotation = get_angle_to(get_global_mouse_position()) + 3.1
	$arrowPointer.set_rotation(arrow_rotation)
	
	if new_anim != anim:
		anim = new_anim
		$animation.play(anim)
	
	if is_on_floor():
		normal = get_floor_normal()
		offset = PI/2
		$image.rotation = normal.angle() + offset
		$CollisionShape2D.rotation = normal.angle() + offset
	
	if is_on_floor():
		_airtime = 0.0
		_jumps = 0
	orbes_en_rango.clear()
	orbes = get_tree().get_nodes_in_group("orbes")
	player_pos = global_position
	mouse_normalized = (get_global_mouse_position()-player_pos).normalized()
	
	for orbe_x in orbes:
		orbe_normalized = (orbe_x.global_position-player_pos).normalized()
		dotProduct = mouse_normalized.dot(orbe_normalized)
		if dotProduct > 0.80:
			orbes_en_rango.append(orbe_x)
	if orbes_en_rango:
		nearest_orbe = orbes_en_rango[0]
		
	else:nearest_orbe = orbes[0]
		
	for orbe_y in orbes_en_rango:
		if orbe_y.global_position.distance_to(player_pos) < nearest_orbe.global_position.distance_to(player_pos):
			nearest_orbe = orbe_y
	
	vectDash = nearest_orbe.global_position - position
	dash_direction = vectDash*dash_speed
	var orbe_final_normalized = (nearest_orbe.global_position-player_pos).normalized()
	dotProduct_final = mouse_normalized.dot(orbe_final_normalized)
	
	if (vectDash.length() < 275) and (dotProduct_final > 0.70) and (nearest_orbe.activado == true or timerOrbe == true):
		nearest_orbe.enRango()


func change_state(new_state):
	state = new_state
	match state:
		IDLE: 
			new_anim = 'idle'
		RUN:
			walkParticles.emitting = true
			new_anim = 'run'
		JUMP:
			new_anim = 'jump_up'
		DASH:
			walkParticles.emitting = false
			new_anim = "dash"
		DEAD:
			new_anim = "death"

func handle_dash() -> void:
	if Input.is_action_just_pressed("dash") and can_dash and deadPlayer == false:
		orbeADashear = nearest_orbe
		VectDashFunc = vectDash
		mouseNormalizedFunc = mouse_normalized
		is_dashing = true
		can_dash = false
		dashDirFunc = VectDashFunc*dash_speed
		dash_timer.start(dash_length)
		orbeFinalNormalizedFunc = (orbeADashear.global_position-player_pos).normalized()
		dotProductFinalFunc = mouseNormalizedFunc.dot(orbeFinalNormalizedFunc)
		
	if is_dashing and (VectDashFunc.length() < 275) and (dotProductFinalFunc > 0.70) and (orbeADashear.activado == true or timerOrbe == true):
		#dash_particles.emmiting = true
		orbeADashear.cooldown()
		velocity = dashDirFunc
		animationDash = true
		change_state(DASH)
		timerOrbe = true
		dash_animationTimer.start(0.4)
		move_and_slide()
		jump_dash = true
		get_node("CPUParticles2D").set_emitting(true)
		
		if  is_on_wall() or deadPlayer == true:
			is_dashing = false
			get_node("CPUParticles2D").set_emitting(false)
			animationDash = false
			if deadPlayer == true:
				deadDashingPlayer = true
				dead()

func dead():
	if deadPlayer == false or deadDashingPlayer == true:
		deadPlayer = true
		deadPlayerMovement = true
		jump_dash = false
		walkParticles.emitting = false
		if gatoEnMano > 0:
			print (gatoEnMano)
			gatoEnMano = 0
			gato.reaparecer()
			game.cats -= 1
			emit_signal("gatoPerdido") 
		change_state(DEAD)

func start(pos):
	position = pos
	show()

func get_input():

	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_pressed("jump")
	
	velocity.x = 0
	if deadPlayer == false:
		if right:
			velocity.x += run_speed
			$image.flip_h = false
		if left:
			velocity.x -= run_speed
			$image.flip_h = true
		if jump and (is_on_floor() or jump_dash == true or _airtime < 0.1):
			velocity.y = -jump_speed
			$image.rotation = 0
			$CollisionShape2D.rotation = 0
			if jump_dash == true:
				audio.stream = load(audios["doubleJump"])
				audio.play()
				jump_dash=false
			else:
				audio.stream = load(audios["jump"])
				audio.play()
		
		if state == DASH and animationDash == false:
			change_state(JUMP)
			
		if state == IDLE and velocity.x != 0:
			change_state(RUN)
			
		if state == RUN and velocity.x == 0:
			walkParticles.emitting = false
			change_state(IDLE)
		
		if state in [IDLE, RUN] and !is_on_floor() and animationDash == false:
			walkParticles.emitting = false
			change_state(JUMP)
		
		if state == JUMP and is_on_floor():
			jump_dash = false
			audio.stream = load(audios["jumpLand"])
			audio.play()
			change_state(IDLE)
		
		if state == JUMP and velocity.y > 0:
			new_anim = 'jump_down'

func _on_dash_timer_timeout():
	is_dashing = false
	can_dash = true
	timerOrbe = false
	get_node("CPUParticles2D").set_emitting(false)

func _on_dash_animation_timer_timeout():
	animationDash = false

func _on_animation_animation_finished(anim_name):
	if anim_name == "death":
		position = game.last_position
		change_state(IDLE)
		deadPlayerMovement = false
		$DeadTimer.start()

func _on_dead_timer_timeout():
		deadDashingPlayer = false
		game.deaths += 1
		deadPlayer = false

func gatoCogido(gatoRef):
	gatoEnMano += 1
	print("gatoCogido")
	gato = gatoRef
	
func guardarGato():
	gato.queue_free()
	gatoEnMano = 0
