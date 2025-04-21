class_name GameLevel
extends Node3D

@export_group("UX settings")
@export var part_value_saved_to_win : float = 0.4
@export var amount_of_key_items : int = 5
@export_group("Technical settings")
@export var player_default_spawn_position = Vector3(4.194, 0.172, 6.712)



var total_value_of_items_on_level : float
var items_value_goal : float
var items_value_stolen : float
var items_value_broken : float
var items_value_secured : float
var items_counter : Dictionary = {
	# name : [total_amount, tasked_amount, stolen_amount, secured_amount]
}

func _ready() -> void:
	GlobalInGame.level = self
	GlobalInGame.level_ready.emit()
	GlobalAudioPlayer.play_music("DayTime")
	await get_tree().create_timer(0.5).timeout
	define_level_goals()
	pass_level_goals()
	connect_signals()

func connect_signals():
	GlobalInGame.item_was_damaged.connect(count_item_damaged)
	GlobalInGame.item_was_stolen.connect(count_item_secured)
	GlobalInGame.item_was_secured.connect(count_item_secured)

func pause_game():
	pass

func define_level_goals():
	total_value_of_items_on_level = 0.0
	# count value of items
	for item in get_tree().get_nodes_in_group("GrabbableObject"):
		if item is GrabbableObject:
			total_value_of_items_on_level += item.value * item.durability / 100
			if items_counter.has(item.listed_name):
				items_counter[item.listed_name][0] += 1
			else:
				items_counter[item.listed_name] = [1,0,0,0]
	# define goal
	items_value_goal = total_value_of_items_on_level * part_value_saved_to_win
	print(items_counter)
	# define key items
	for i in amount_of_key_items:
		var key_item : GrabbableObject = get_tree().get_nodes_in_group("GrabbableObject").pick_random()
		items_counter[key_item.listed_name][1] += 1

func pass_level_goals():
	var level_key_items : Dictionary = {} # name : amount_to_get
	for item in items_counter:
		if items_counter[item][1] > 0:
			level_key_items[item] = items_counter[item][1]
	
	GlobalInGame.pass_starting_data_to_UI(
		level_key_items ,
		roundi(total_value_of_items_on_level) ,
		total_value_of_items_on_level * (1 - part_value_saved_to_win),
		total_value_of_items_on_level * part_value_saved_to_win
	)

func count_item_damaged(amount : float):
	items_value_broken += amount
	GlobalInGame.pass_negative_progression(
		roundi(items_value_stolen + items_value_broken))

func count_item_stolen(item : GrabbableObject):
	print(item)
	var item_stolen = item
	items_value_stolen += item.value * item.durability / 100
	GlobalInGame.pass_negative_progression(
		roundi(items_value_stolen + items_value_broken))
	items_counter[item_stolen.listed_name][2] += 1
	if items_counter[item_stolen.listed_name][1] < items_counter[item_stolen.listed_name][0] - items_counter[item_stolen.listed_name][2]:
		GlobalInGame.game_over.emit()

func count_item_secured(item : GrabbableObject):
	var item_secured = item
	items_value_secured += item.value * item.durability / 100
	GlobalInGame.pass_positive_progression(
		roundi(items_value_secured))
	GlobalInGame.pass_collected_items_data_to_UI(
		{item_secured.listed_name : 1}
	)
