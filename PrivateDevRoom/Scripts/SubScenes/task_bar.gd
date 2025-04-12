class_name TaskBar
extends Control

@export var tasks_container : VBoxContainer

func get_task_list(tasks_dictionary : Dictionary) -> void:
	for task in tasks_dictionary:
		tasks_container.add_child(
			TaskProgress.new_task(task, tasks_dictionary[task]))

func new_items_collected(items_dictionary : Dictionary):
	for item in items_dictionary:
		for task in tasks_container.get_children():
			if task is TaskProgress:
				if task.objective == item:
					task.items_collected(items_dictionary[item])
					break
