class_name LevelProgressBar
extends PanelContainer

@export_group("Internal connections")
@export var positive_progress_bar : ProgressBar
@export var negative_progress_bar : ProgressBar
@export var extra_progress_bar : ProgressBar

func _ready() -> void:
	reset_progress_bars()

func get_level_progress_values(amount_to_pass : int , amount_to_fail : int , total_amount : int) -> void:
	extra_progress_bar.max_value = total_amount - amount_to_pass
	positive_progress_bar.max_value = amount_to_pass * 2
	negative_progress_bar.max_value = amount_to_fail * 2

func update_positive_progress(new_progress : int) -> void:
	if positive_progress_bar.value == positive_progress_bar.max_value:
		extra_progress_bar.value = new_progress - positive_progress_bar.max_value
	else:
		if new_progress > positive_progress_bar.max_value:
			positive_progress_bar.value = positive_progress_bar.max_value
			extra_progress_bar.value = new_progress - positive_progress_bar.max_value
		else:
			positive_progress_bar.value = new_progress

func update_negative_progress(new_progress : int) -> void:
	negative_progress_bar.value = new_progress

func reset_progress_bars() -> void:
	positive_progress_bar.value = 0
	negative_progress_bar.value = 0
	extra_progress_bar.value = 0
