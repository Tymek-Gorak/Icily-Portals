extends Node
class_name OnStartEnable

@export var game_start_nodes : Array[Node2D]

func _ready():
	for node in game_start_nodes:
		node.visible = false
	GameManager.connect("start_game", start)


func start():
	for node in game_start_nodes:
		node.visible = true
	queue_free()
