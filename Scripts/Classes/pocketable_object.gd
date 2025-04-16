class_name PocketableObject
extends InteractableObject

@export var icon : CompressedTexture2D

func grab_in_pocket():
	# if [MVP request to player UI]:
	# item data stored in inventory pocket UI
	disable_existence()
	# return true # for grab animation, if will be implemented

func disable_existence() -> void:
	get_parent().remove_child(self)
	set_physics_process(false)
	set_process(false)
	sleeping = true
	hide()

func enable_existence(player) -> void:
	player.get_parent().add_child(self) # MVP should have proper reference to current game scene
	set_physics_process(true)
	set_process(true)
	sleeping = false
	global_position = player.global_position
	show()
