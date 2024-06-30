extends Area2D

signal pickupCat
signal pickupCoin

var tipoColeccionable
var enabled = true

var audios = {
	"gato": "res://01_assets/03_sound/01_sfx/CatObtained.wav",
	"coin": "res://01_assets/03_sound/01_sfx/PickUp.wav"
}

var textures = {
	'gato3': "res://01_assets/01_sprites/BST_ch_gatoColeccionable03_v01.png",
	'gato2': "res://01_assets/01_sprites/BST_ch_gatoColeccionable02_v01.png",
	'gato1': "res://01_assets/01_sprites/BST_ch_gatoColeccionable01_v01.png",
	'alma': "res://01_assets/01_sprites/almas_SpriteSheet.png"
}

func setup(type, pos, texture):
	$image.texture = load(textures[texture])
	if type == "coin":
		$image.hframes = 2
		$image.vframes = 2
		$animation.play("anim")
	position = pos
	tipoColeccionable = type
	
#para los rigid/character body necesitan conectarse tiene que ser body entered no area entered
func _on_body_entered(body):
	if body.name == "player" and body.deadPlayer == false and enabled == true:
		if tipoColeccionable == "gato":
			emit_signal("pickupCat")
			$image.visible = false
			body.gatoCogido(self)
			enabled = false
		if tipoColeccionable == "coin":
			emit_signal("pickupCoin")
			queue_free()

func reaparecer():
	enabled = true
	$image.visible = true
