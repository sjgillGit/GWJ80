extends Node

var player

#region in-game-UI 
var player_UI : InGameUI
signal nighttime_starts

func pass_starting_data_to_UI(current_level_tasks : Dictionary ,
	level_total_objects_value : int ,
	level_value_to_fail : int , level_value_to_pass: int):
	
	player_UI.pass_tasks(current_level_tasks)
	player_UI.pass_level_progress_values(
		level_value_to_pass, level_value_to_fail, level_total_objects_value
	)


func pass_time_to_UI(current_time_sec : int):
	player_UI.update_timer(current_time_sec)


func store_item_in_pockets(item_to_store : PocketableObject) -> bool:
	return player_UI.pockets_add_item(item_to_store)

func drop_item_from_pocket() -> PocketableObject:
	return player_UI.drop_item_in_selected_slot()


func pass_collected_items_data_to_UI(items_collected : Dictionary) -> void:
	player_UI.pass_collected_items_amount(items_collected)


func pass_positive_progression(total_value_collected : int) -> void:
	player_UI.level_progress_update_positive_progress(total_value_collected)

func pass_negative_progression(total_value_damaged : int) -> void:
	player_UI.level_progress_update_negative_progress(total_value_damaged)

#endregion
