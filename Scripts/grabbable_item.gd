class_name GrabbableItem 
extends InteractableItem

@onready var player: PlayerController = get_tree().get_nodes_in_group("Player")[0] 

func interact():
	player.set_grabbed_item(self)
	pass
