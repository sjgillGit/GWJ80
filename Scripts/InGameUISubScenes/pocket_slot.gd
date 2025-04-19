class_name PocketSlot
extends CenterContainer

@export_group("Internal connections")
@export var icon : TextureRect
@export var selected_border : NinePatchRect

var stored_item = "Test_pseudo_item"
var selected : bool = false :
	set(new_value):
		selected = new_value
		selected_border.visible = selected

# TODO adapt to items properties
func take_item(new_item : PocketableObject) -> void:
	stored_item = new_item
	icon.texture = new_item.icon

func give_item():
	var item_to_return = stored_item
	icon.texture = null
	stored_item = null
	return item_to_return
