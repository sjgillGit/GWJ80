extends RayCast3D

@onready var prompt_label: Label = get_node("InteractionPromptLabel")

var player : PlayerController

func _process(_delta):
	var object: Object = get_collider()
	prompt_label.text = ""

	if object and object is GrabbableObject:
		prompt_label.text = "[E] " + object.interaction_prompt
		
		object.change_outline_color(Color.WEB_GREEN)
		## TODO: Implement better grabbed item check to avoid picking up two items at the same time
		#if Input.is_action_just_pressed("grab_item"):
			#if ObjectInteraction.grabbed_item == null:
				#ObjectInteraction.set_player_grabbable_item(object)
			#else:
				#ObjectInteraction.unset_player_grabbable_item()
		
		if Input.is_action_pressed("grab_item"):
			player.set_grabbed_item(object)
