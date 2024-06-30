extends CanvasLayer

@onready var cats_label = $interface/margin/HBoxContainer/scoreCats
@onready var coins_label = $interface/margin/HBoxContainer/scoreCoins

var audios = {
	"gato": "res://01_assets/03_sound/01_sfx/CatObtained.wav",
	"coin": "res://01_assets/03_sound/01_sfx/PickUp.wav"
}

func _ready():
	cats_label.text = (str(game.cats))
	coins_label.text = str(game.coins)

func _on_level_template_cats_changed():
	cats_label.text = (str(game.cats))
	$PickupGato_Sound.play()

func _on_level_template_coins_changed():
	coins_label.text = str(game.coins)
	$PickupAlma_Sound.play()

func _on_player_gato_perdido():
	cats_label.text = (str(game.cats))
