extends Control

@onready var cats_label = $HBoxContainer/scoreCats
@onready var almas_label = $HBoxContainer/scoreAlmas
@onready var muertes_label = $scoreCats
var musicFail = "res://01_assets/03_sound/02_music/lose.wav"

var screens = {
	0: "res://01_assets/01_sprites/0CatsFinal.png",
	1: "res://01_assets/01_sprites/1CatFinal.png",
	2: "res://01_assets/01_sprites/2CatsFinal.png",
	3: "res://01_assets/01_sprites/3CatsFinal.png",
}
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	almas_label.text = (str(game.coins))
	cats_label.text = (str(game.cats))
	$image.texture = load(screens[game.cats])
	muertes_label.text = ("Muertes: "+ str(game.deaths))

func _on_retry_button_pressed():
	game.restart()
	queue_free()


func _on_exit_button_pressed():
	get_tree().quit()

func _on_video_stream_player_finished():
	get_tree().paused = false
	if game.cats == 0:
		$AudioStreamPlayer.stream = load(musicFail)
		$AudioStreamPlayer.play()
	$VideoStreamPlayer.queue_free()
