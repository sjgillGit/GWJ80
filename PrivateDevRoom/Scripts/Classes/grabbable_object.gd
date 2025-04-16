class_name GrabbableObject
extends InteractableObject

#@export_group("Internal Connections")
@export_group("Grabbing settings")
@export var drag_max_distance : float = 1500
@export var stiffness : float = 350.0
@export var damping : float = 15.0

var to_follow_global_position : Vector3
var is_grabbed : bool = false

# temp var
var interaction_prompt = ""

func get_grabbed():
	print(self, " is grabbed")
	is_grabbed = true

func get_dropped():
	is_grabbed = false

func move_bubble(to_global_position : Vector3) -> void:
	to_follow_global_position = to_global_position
	print(to_follow_global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if is_grabbed:
		var displacement = to_follow_global_position - global_position
		var discance_sq = displacement.length_squared()
		
		if discance_sq > drag_max_distance * drag_max_distance:
			get_dropped()
			print("Item was dropped!")
			return
		
		var spring_force = displacement * stiffness
		var damping_force = -state.linear_velocity * damping
		state.apply_force(spring_force + damping_force)
