class_name MessageBox
extends Control

# TODO chage path before merging into main
const SELF_SCENE : PackedScene = preload("res://PrivateDevRoom/Scenes/message_box.tscn") 

@export_group("Internal connections")
@export var title_label : Label
@export var message_label : Label


static func new_messsage_box(title : String , text : String) -> MessageBox:
	var new_message_box : MessageBox = SELF_SCENE.instantiate()
	new_message_box.title_label.text = title
	new_message_box.message_label.text = text
	return new_message_box


func _on_exit_pressed() -> void:
	if visible:
		hide()
		queue_free()
