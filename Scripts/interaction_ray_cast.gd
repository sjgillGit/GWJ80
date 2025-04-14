extends RayCast3D

@onready var prompt_label: Label = get_node("InteractionPromptLabel")

func _process(_delta):
	var object: Object = get_collider()
	prompt_label.text = ""

	if object and object is InteractableItem:
		prompt_label.text = "[E] " + object.interaction_prompt
		
		# TODO: Implement better grabbed item check to avoid picking up two items at the same time
		if Input.is_action_just_pressed("grab_item"):
			if ObjectInteraction.grabbed_item == null:
				ObjectInteraction.set_player_grabbable_item(object)
			else:
				ObjectInteraction.unset_player_grabbable_item()
				
