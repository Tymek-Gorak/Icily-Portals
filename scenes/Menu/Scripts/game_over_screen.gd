extends NinePatchRect


@onready var money_made_text : RichTextLabel = %MoneyMadeText
@onready var money_spent_text : RichTextLabel = %MoneySpentText
@onready var dmg_taken_text: RichTextLabel = %DMGTakenText
@onready var profit_text : RichTextLabel = %ProfitText
@onready var high_score_text : RichTextLabel = %HighScoreText
@onready var icecream_dropped_text : RichTextLabel = %IcecreamDroppedText
@onready var new_high_score_box : NinePatchRect = $NewHighScoreBox

@onready var high_score_particles_box : Array[CPUParticles2D] = [$NewHighScoreBox/CPUParticles2D, $NewHighScoreBox/CPUParticles2D2]

var is_high_score:=false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	GameManager.connect("end_game", game_over)
	GameManager.connect("new_high_score", new_high_score)

func new_high_score():
	is_high_score = true

func game_over():
	visible = true
	var tween = create_tween()
	tween.tween_property(money_made_text,"text", str(GameManager.money_made), .3)
	tween.tween_property(money_spent_text,"text", str(GameManager.money_made - GameManager.money), .3)
	tween.tween_property(dmg_taken_text,"text",  str(GameManager.dmg_taken), .3)
	tween.tween_property(icecream_dropped_text,"text",  str(GameManager.icecream_wasted), .3)
	tween.tween_property(profit_text,"text",  str(GameManager.money), .3)
	tween.tween_property(high_score_text,"text",  str(GameManager.high_score), .3)
	if is_high_score:
		tween.tween_property(new_high_score_box,"visible",  true, .3)
		for particles : CPUParticles2D in high_score_particles_box:
			tween.tween_property(particles, "emitting", true, 0)
