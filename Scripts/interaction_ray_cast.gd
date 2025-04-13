extends RayCast3D

@onready var prompt_label: Label = get_node("InteractionPromptLabel")

func _process(_delta):
	var object: Object = get_collider()
	prompt_label.text = ""

	if object and object is InteractableItem:
		prompt_label.text = "[E] " + object.interaction_prompt
		
		if Input.is_action_just_pressed("grab_item"):
			object.interact()
