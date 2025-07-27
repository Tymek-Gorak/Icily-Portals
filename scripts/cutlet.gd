extends CharacterBody2D
class_name Cutlet


enum HEAD_ITEM_TYPES {POTION, ICECREAM, NONE}

@export var head_potion_spacing = 20
var capacity = 3
var holding : Array[HeadItem]

var is_throwing := false

@export var MAX_SPEED := 250
@export var ACCELERATION := 1200
@export var DECCELERATION := 2250
@export var KNOCKBACK := 700
@export var POTION_RANGE := 175
@export var PUSH_FORCE := 15
@export var THROW_COOLDOWN := .2
@export var THROW_COOLDOWN_MOBILE := .4
@export var head_potion : PackedScene
@export var head_icecream : PackedScene
@export var thrown_potion : PackedScene
@export var thrown_icecream : PackedScene
@export var head_container : Node2D

@onready var splash_zone = $SplashZone
@onready var i_frames = $IFrames
@onready var throw_frequency : Timer = $ThrowFrequency
@onready var buy_area = $BuyArea
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

func _init() -> void:
	GameManager.player = self

func _ready():
	GameManager.player = self
	animation_player.play("idle_forward")
	if GameManager.is_touch_screen_device:
		MAX_SPEED = 250
		ACCELERATION = 1200
		DECCELERATION = 2250

func _physics_process(delta):
	var move_direction = Input.get_vector("left", "right", "up", "down")

	var aim_direction = Input.get_vector("aim_left","aim_right","aim_up","aim_down")

	if GameManager.is_touch_screen_device:
		move_direction = GameManager.joystick_movement.movement_direction
		if move_direction.is_zero_approx(): move_direction = Vector2.ZERO

		#aim appropriatly based on which movement mode is slected
		match GameManager.control_type:
			GameManager.CONTROL_TYPES.ONE_HANDED:
				if get_next_head_item_type() == HEAD_ITEM_TYPES.POTION:
					#find the closest portal
					var closest_portal_position := Vector2(99999,99999)
					for portal : Node2D in get_tree().get_nodes_in_group("Portals"):
						#array storing the distance to every portal on screen
						if global_position.distance_to(portal.global_position) < global_position.distance_to(closest_portal_position):
							closest_portal_position = portal.global_position

					# only change the aiming directions if portals are on screen
					if get_tree().get_node_count_in_group("Portals") > 0:
						aim_direction = global_position.direction_to(closest_portal_position)
				elif get_next_head_item_type() == HEAD_ITEM_TYPES.ICECREAM:
					#aim at counter
					aim_direction = position.direction_to(get_tree().get_first_node_in_group("Counter").position)
			_:
				if not GameManager.joystick_action.aim_direction.is_zero_approx():
					aim_direction = GameManager.joystick_action.aim_direction



	if not aim_direction.is_zero_approx():
		splash_zone.position = aim_direction.normalized() * POTION_RANGE
	elif not move_direction.is_zero_approx():
		splash_zone.position = move_direction.normalized() * POTION_RANGE

	if i_frames.time_left > i_frames.wait_time * 0.8:
		move_direction = Vector2.ZERO


	#region animations
	if not velocity.is_zero_approx():
		AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.WALK)
		if move_direction.y < 0:
			animation_player.play("walk_backwards")
		elif move_direction.y > 0:
			animation_player.play("walk_forward")
		if move_direction.x != 0:
			if animation_player.current_animation == "idle_backwards": animation_player.play("walk_backwards")
			if animation_player.current_animation == "idle_forward": animation_player.play("walk_forward")
	else:
		AudioManager.clear_audio(AudioResource.AUDIO_TYPES.WALK)
		if animation_player.current_animation == "walk_backwards": animation_player.play("idle_backwards")
		if animation_player.current_animation == "walk_forward": animation_player.play("idle_forward")
	#endregion

	if GameManager.is_touch_screen_device and GameManager.control_type == GameManager.CONTROL_TYPES.ONE_HANDED:
		if velocity.is_zero_approx():
			if throw_frequency.is_stopped():
				throw_frequency.start(THROW_COOLDOWN_MOBILE)
				await get_tree().create_timer(.1).timeout
				throw()
		else:
			throw_frequency.stop()

	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false

	if not is_zero_approx(velocity.dot(move_direction)):
		velocity = velocity.move_toward(move_direction * MAX_SPEED, ACCELERATION *delta)
	else:
		velocity = velocity.move_toward(move_direction * MAX_SPEED, DECCELERATION *delta)

	move_and_slide()

	#pick up and collide with potions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collision = c.get_collider()
		if collision is PotionPickUp:
			if holding.size() < capacity and collision.spent == false:
				c.get_collider().spent = true
				c.get_collider().queue_free()
				if collision is IcecreamPickUp:
					add_head_item(HEAD_ITEM_TYPES.ICECREAM)
				elif collision is PotionPickUp:
					add_head_item(HEAD_ITEM_TYPES.POTION)
				continue
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)

func _input(event):
	if event.is_action_pressed("throw"):
		throw_frequency.start(THROW_COOLDOWN)
		throw()
	elif event.is_action_released("throw"):
		throw_frequency.stop()

	if event.is_action_pressed("interact"):
		interact()

	if GameManager.is_touch_screen_device and GameManager.control_type != GameManager.CONTROL_TYPES.ONE_HANDED:
		if GameManager.joystick_action.aim_direction.length() > 0.85:
			if throw_frequency.is_stopped():
				throw_frequency.start(THROW_COOLDOWN_MOBILE)
		else:
			throw_frequency.stop()




func add_head_item(item_type : HEAD_ITEM_TYPES):
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.PICK_UP_PICK_UP)
	var item
	if item_type == HEAD_ITEM_TYPES.POTION:
		item = head_potion.instantiate()
	elif item_type == HEAD_ITEM_TYPES.ICECREAM:
		item = head_icecream.instantiate()
	head_container.add_child(item)
	item.position.y -= (holding.size()) * head_potion_spacing
	holding.append(item)
	if item_type == HEAD_ITEM_TYPES.ICECREAM and %SellArea.get_overlapping_areas().size() > 0:
		throw()

func remove_next_head_item():
	if head_container.get_child_count() < 1:
		#no items to remove
		return
	var head_items : Array[Node] = head_container.get_children()
	head_items[head_container.get_child_count()-1].free()
	holding.pop_back()

func sell_head_ice_cream(counter : Counter = get_tree().get_first_node_in_group("Counter")):
	var potion_count := 0
	for i in range(head_container.get_child_count()-1,-1,-1):
		if head_container.get_children()[i] is HeadIcecream:
			throw()
		else:
			potion_count += 1
			remove_next_head_item()
	for potion in potion_count:
		add_head_item(HEAD_ITEM_TYPES.POTION)


func throw():
	if holding.size() < 1: return
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.THROW)
	var thrown_item : ThrownPotion
	if holding[holding.size()-1] is HeadIcecream:
		thrown_item = thrown_icecream.instantiate()
	elif holding[holding.size()-1] is HeadItem:
		thrown_item = thrown_potion.instantiate()
	head_container.get_children()[head_container.get_child_count()-1].free()
	holding.pop_back()

	thrown_item.throw_direction = splash_zone.position.normalized()
	thrown_item.position = position
	get_parent().call_deferred("add_child", thrown_item)

func interact():
	if  buy_area.get_overlapping_areas().size() <= 0:
		return
	var upgrade_button : UpgradeButton = buy_area.get_overlapping_areas()[0]
	upgrade_button.buy()

func get_hit(area : Area2D):
	if not i_frames.is_stopped():
		return

	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.DMG_TAKEN)
	GameManager.dmg_taken += 1
	var tween = create_tween()
	tween.tween_property(sprite_2d, "self_modulate", Color.TRANSPARENT,0)
	tween.tween_property(sprite_2d, "self_modulate", Color.WHITE,2).set_ease(Tween.EASE_OUT)

	var hit_direction := (global_position - area.global_position).normalized()
	velocity = hit_direction * KNOCKBACK
	i_frames.start()
	for item : HeadItem in head_container.get_children():
		item.drop()
	holding = []




func get_next_head_item_type() -> HEAD_ITEM_TYPES:
	if holding.size() < 1:
		return HEAD_ITEM_TYPES.NONE
	var next_head_item = holding[holding.size()-1]
	if next_head_item is HeadIcecream:
		return HEAD_ITEM_TYPES.ICECREAM
	elif next_head_item is HeadItem:
		return HEAD_ITEM_TYPES.POTION
	return HEAD_ITEM_TYPES.NONE
