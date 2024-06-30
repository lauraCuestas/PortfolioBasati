extends Node2D
var activado = true

func _ready():
	$Sprite2D.modulate = Color(1,1,1,0.7)

func cooldown():
	$AnimationPlayer.play("cooldown")
	activado = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cooldown":
		$AnimationPlayer.play("idle")
		activado = true

func enRango():
	$GPUParticles2D.visible = true
	$Sprite2D.modulate = Color(1,1,1,1)
	$Timer.start()

func _on_timer_timeout():
	$GPUParticles2D.visible = false
	$Sprite2D.modulate = Color(1,1,1,0.7)
