extends Marker2D
class_name PortalSpawnArea

var spawn_area_bottom_right_corner : Marker2D
var big_portal_odds = 100
var small_portal_odds = 0
var laser_portal_odds = 0

var PORTAL_SCENES : Array[PackedScene]= [
	preload("res://scenes/prefabs/portal_bigshot.tscn"),
	preload("res://scenes/prefabs/portal_base.tscn"),
	preload("res://scenes/prefabs/portal_laser.tscn"),
	]

@onready var portal_spawn_timer = $PortalSpawnTimer

func _ready():
	GameManager.connect("start_game", start)
	GameManager.connect("update_portal_odds_signal", change_portal_odds)
	GameManager.connect("update_portal_spawn_rate_signal", change_portal_spawn_rate)
	GameManager.connect("spawn_portal_signal", _on_portal_spawn_timer_timeout)
	for child in get_children():
		if child is Marker2D:
			spawn_area_bottom_right_corner = child

func start():
	portal_spawn_timer.start()

func change_portal_odds(big_odds, small_odds, laser_odds):
	big_portal_odds = big_odds
	small_portal_odds = small_odds
	laser_portal_odds = laser_odds

func change_portal_spawn_rate(new_spawn_rate):
	portal_spawn_timer.wait_time = new_spawn_rate

func spawn_portal(portal_type : GameManager.PORTAL_TYPES , spawn_position : Vector2):
	var portal : PortalBase = PORTAL_SCENES[portal_type].instantiate()
	get_parent().add_child(portal)
	portal.global_position = spawn_position
	GameManager.portals_on_screen += 1

func _on_portal_spawn_timer_timeout():
	if GameManager.portals_on_screen >= GameManager.portal_cap:
		return
	var portal_rng = randi_range(0, 100)
	var portal_type : GameManager.PORTAL_TYPES
	if portal_rng <= big_portal_odds:
		portal_type = GameManager.PORTAL_TYPES.BIGSHOT
	elif portal_rng <= big_portal_odds + small_portal_odds:
		portal_type = GameManager.PORTAL_TYPES.SMALLSHOT
	elif portal_rng <= big_portal_odds + small_portal_odds + laser_portal_odds:
		portal_type = GameManager.PORTAL_TYPES.LASER

	var portal_x = randf_range(global_position.x, spawn_area_bottom_right_corner.global_position.x)
	var portal_y = randf_range(global_position.y, spawn_area_bottom_right_corner.global_position.y)

	spawn_portal(portal_type, Vector2(portal_x,portal_y))
