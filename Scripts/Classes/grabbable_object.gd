class_name GrabbableObject
extends InteractableObject

#@export_group("Internal Connections")
@export_group("Grabbing settings")
@export var drag_max_distance : float = 3.0
@export var stiffness : float = 110.0
@export var damping : float = 50.0

var to_follow_global_position : Vector3
var is_grabbed : bool = false:
	set(new_value):
		set_collision_layer_value(1, !new_value)
		set_collision_layer_value(4, new_value)
		is_grabbed = new_value
		
var been_stolen : bool = false:
	set(new_value):
		lock_rotation = new_value
		been_stolen = new_value
		set_collision_layer_value(1, !new_value)
		set_collision_layer_value(4, new_value)
		for child in get_children():
			if child is NavigationAgent3D:
				child.avoidance_enabled = !new_value
		
			
signal self_drop

# temp var
var interaction_prompt = ""

func get_grabbed():
	is_grabbed = true

func get_dropped():
	is_grabbed = false


func move_bubble(to_global_position : Vector3) -> void:
	to_follow_global_position = to_global_position

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if is_grabbed:
		var displacement = to_follow_global_position - global_position
		var discance_sq = displacement.length_squared()
		
		if discance_sq > drag_max_distance * drag_max_distance:
			self_drop.emit()
			return
		
		var spring_force = displacement * stiffness
		var damping_force = -state.linear_velocity * damping
		state.apply_force(spring_force + damping_force)
