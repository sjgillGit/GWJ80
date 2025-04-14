class_name TimerPanel
extends PanelContainer

@export_group("Internal connections")
@export var time_label : Label

var nighttime_triggered : bool = false

func update_time(new_time_seconds : int) -> void:
	if nighttime_triggered: return
	time_label.text = "%02d:%02d" % [roundi(new_time_seconds / 60) , new_time_seconds % 60]

func trigger_nighttime() -> void:
	time_label.text = "Night"
	nighttime_triggered = true
