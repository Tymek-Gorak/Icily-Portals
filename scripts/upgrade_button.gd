extends Area2D
class_name UpgradeButton

@export var prices : Array[int]= [50]
@export var descriptions : Array[String] = ["sample"]
@export var upgrade_function : UpgradeBase
@export var tiers = 1
var curr_tier = 0


@onready var sprite_2d = $Sprite2D
@onready var description = %Description
@onready var price_text = %Price
@onready var text_container = $TextContainer


func _ready():
	GameManager.connect("money_amount_changed", update_button_color)
	price_text.text = str(prices[curr_tier]).to_upper()
	description.text = descriptions[curr_tier].to_upper()

func update_button_color(money=null	):
	if GameManager.money - prices[curr_tier] >= 0:
		sprite_2d.region_rect = Rect2(106, 11, 116, 33)
		sprite_2d.flip_h = true
		sprite_2d.self_modulate = Color.WHITE
	else:
		sprite_2d.region_rect = Rect2(0, 11, 116, 33)
		sprite_2d.flip_h = false
		sprite_2d.self_modulate = Color.RED



func buy():


	if GameManager.money - prices[curr_tier] >= 0:
		AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.UPGRADE_BOUGHT)
		upgrade_function.upgrade(curr_tier)
		GameManager.money -= prices[curr_tier]
		curr_tier += 1
		if curr_tier == tiers:
			delete()
			return
		update_button_color()
		price_text.text = str(prices[curr_tier]).to_upper()
		description.text = descriptions[curr_tier].to_upper()
	else:

		AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.UPGRADE_TOO_EXPENSIVE)


func _on_body_entered(body):
	text_container.position.y +=5
	sprite_2d.frame = 1

func _on_body_exited(body):
	text_container.position.y -=5
	sprite_2d.frame = 0

func delete():
	queue_free()
