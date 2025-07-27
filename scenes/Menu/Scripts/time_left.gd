extends NinePatchRect
class_name  TimeLeft

@onready var timer_text = $TimerText
@onready var time_remaining : int = GameManager.time_remaining

func _ready():
	GameManager.connect("start_game", $CountingSeconds.start)
	if time_remaining % 60 >= 10:
		timer_text.text = str(time_remaining / 60) + ":" + str(time_remaining % 60)
	else:
		timer_text.text = str(time_remaining / 60) + ":0" + str(time_remaining % 60)


func _on_counting_seconds_timeout():
	if time_remaining % 60 >= 10:
		timer_text.text = str(time_remaining / 60) + ":" + str(time_remaining % 60)
	else:
		timer_text.text = str(time_remaining / 60) + ":0" + str(time_remaining % 60)

	time_remaining -= 1
	if time_remaining == 60:
		timer_text.add_theme_color_override("default_color", Color.RED)
	if time_remaining == -1:
		GameManager.end()
