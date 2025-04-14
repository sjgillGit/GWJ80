class_name MessageBox
extends Control

@export_group("Internal connections")
@export var title_label : Label
@export var message_label : Label


static func new_messsage_box(title : String , text : String) -> MessageBox:
	#var new_message_box_scene = load(Global.SCENES_DICTIONARY.MessageBox) # Uncomment after setting up global
	var new_message_box_scene = load("res://PrivateDevRoom/Scenes/message_box.tscn") # < Temp
	var new_message_box : MessageBox = new_message_box_scene.instantiate()
	new_message_box.title_label.text = title
	new_message_box.message_label.text = text
	return new_message_box


func _on_exit_pressed() -> void:
	if visible:
		hide()
		queue_free()
