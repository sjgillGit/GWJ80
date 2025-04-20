extends ShapeCast3D

@onready var prompt_label: Label = get_node("InteractionPromptLabel")

var player: PlayerController

func _physics_process(delta: float) -> void:
	force_shapecast_update()
	if !is_colliding():
		player.object_to_grab = null
		return
	
	var object  = get_collider(0)
	if object is GrabbableObject:
		if player.object_to_grab != object:
			player.object_to_grab = object
