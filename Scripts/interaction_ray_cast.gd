extends RayCast3D

@onready var prompt_label: Label = get_node("InteractionPromptLabel")

var player: PlayerController

func _process(_delta):
	var object: Object = get_collider()
	prompt_label.text = ""

	if object is not InteractableObject:
		return

	player.object_to_grab = object
