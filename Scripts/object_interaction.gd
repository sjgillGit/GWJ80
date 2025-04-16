#extends Node3D
#
#@onready var player: PlayerController = get_tree().get_nodes_in_group("Player")[0]
#
#var grabbed_item: GrabbableObject
#
#func set_player_grabbable_item(item: GrabbableObject):
	#grabbed_item = item
	#player.set_grabbed_item(grabbed_item)
#
#func unset_player_grabbable_item():
	#grabbed_item = null
	#player.drop_item()
