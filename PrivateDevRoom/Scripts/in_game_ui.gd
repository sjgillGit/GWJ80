class_name InGameUI
extends CanvasLayer

@export_group("Internal connections")
@export var timer_panel : TimerPanel
@export var task_bar : TaskBar
@export var pocket_inventory : PocketInventory

#region TimerPanel
func update_timer(new_time_seconds : int) -> void:
	timer_panel.update_time(new_time_seconds)

# TODO Connect to in-game-global signal of nighttime
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
func pockets_select_next_pocket_slot() -> void:
	pocket_inventory.select_next_pocket()

func pockets_select_previous_pocket_slot() -> void:
	pocket_inventory.select_previous_pocket()

func pockets_add_item(item_to_collect) -> bool:
	return pocket_inventory.collect_item(item_to_collect)

func drop_item_in_selected_slot() : # -> pocket_item class
	return pocket_inventory.drop_item_in_selected_slot()
#endregion
