class_name InGameUI
extends CanvasLayer

@export_group("Internal connections")
@export var timer_panel : TimerPanel
@export var task_bar : TaskBar
@export var pocket_inventory : PocketInventory
@export var level_progress_bar : LevelProgressBar

func _ready() -> void:
	GlobalInGame.player_UI = self
	GlobalInGame.nighttime_starts.connect(nighttime_triggered)

#region TimerPanel
func update_timer(new_time_seconds : int) -> void:
	timer_panel.update_time(new_time_seconds)

func nighttime_triggered() -> void:
	timer_panel.trigger_nighttime()
#endregion

#region TaskBar
func pass_tasks(tasks_dictionary : Dictionary) -> void:
	task_bar.get_task_list(tasks_dictionary)

func pass_collected_items_amount(collected_items_dictionary : Dictionary) -> void:
	task_bar.new_items_collected(collected_items_dictionary)
#endregion

#region PocketInventory
#func pockets_select_next_pocket_slot() -> void:
	#pocket_inventory.select_next_pocket()
#
#func pockets_select_previous_pocket_slot() -> void:
	#pocket_inventory.select_previous_pocket()
#
#func pockets_add_item(item_to_collect : PocketableObject) -> bool:
	#return pocket_inventory.collect_item(item_to_collect)
#
#func drop_item_in_selected_slot() : # -> pocket_item class
	#return pocket_inventory.drop_item_in_selected_slot()
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.is_action_pressed("pockets_next_slot"):
			#pocket_inventory.select_next_pocket()
		#elif event.is_action_pressed("pockets_prev_slot"):
			#pocket_inventory.select_previous_pocket()
#endregion

#region LevelProgressBar
func pass_level_progress_values(value_to_pass : int , value_to_fail : int , total_value_on_level : int):
	level_progress_bar.get_level_progress_values(value_to_pass,value_to_fail,total_value_on_level)

func level_progress_update_positive_progress(new_positive_amount : int) -> void:
	level_progress_bar.update_positive_progress(new_positive_amount)

func level_progress_update_negative_progress(new_damage_amount : int) -> void:
	level_progress_bar.update_negative_progress(new_damage_amount)
#endregion
