extends PanelContainer
class_name UIBackDrop

const MENU_PATHS : Dictionary[String, StringName] = {
	"skins" : "res://scenes/Menu/pause_menu.tscn",
	"stats" : "res://scenes/Menu/pause_menu.tscn",
	"credits" : "res://scenes/Menu/pause_menu.tscn",
}

var opening_menu : StringName

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var menu_box: MarginContainer = %MenuBox


func _ready() -> void:
	animation_player.play_backwards("back_drop_despawn")
	await animation_player.animation_finished

	load_menu(opening_menu)

func load_menu(menu_path : StringName):
	animation_player.play("close_menu")
	await animation_player.animation_finished
	for child in menu_box.get_children():
		child.queue_free()
	var new_menu = load(menu_path).instantiate()
	for child : CanvasItem in menu_box.get_children(true):
		child.use_parent_material = true
	menu_box.add_child(new_menu)
	new_menu.position = position
	animation_player.play_backwards("close_menu")


func _on_quit_button_button_up() -> void:
	animation_player.play("back_drop_despawn")
	await animation_player.animation_finished
	queue_free()
