class_name TaskProgress
extends PanelContainer

@export_group("Internal connections")
@export var task_label : Label
@export var task_checkbox : CheckBox


const self_scene : PackedScene = preload("res://PrivateDevRoom/Scenes/SubScenes/task_progress.tscn")

var objective : String = "Test objective"
var to_collect : int = 1
var collected : int = 0

static func new_task(new_objective : String , new_amount : int = 1) -> TaskProgress:
	var task : TaskProgress = self_scene.instantiate()
	task.objective = new_objective
	task.to_collect = new_amount
	return task

func _ready() -> void:
	_update_label()

func _update_label() -> void:
	task_label.text = "[%d / %d] %s" % [collected, to_collect, objective]

func items_collected(new_amount_collected : int) -> void:
	collected += new_amount_collected
	_update_label()
	if collected >= to_collect:
		task_checkbox.set_pressed_no_signal(true)
		#objective = "" # Disables visualization of more then tasked about of items. Up for discustion
