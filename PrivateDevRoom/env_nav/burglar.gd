class_name BurglarNpc
extends default_npc_nav


@export_enum("Idle", "NightIdle", "Get_the_item", "Stolen_item", "Lost_item") var state : String
@export var detection_radius : float = 10

@onready var detection_area : Area3D = $DetectionArea
@onready var detection_area_shape : CollisionShape3D = $DetectionArea/DetectionShape

var target_object : GrabbableObject

func _ready() -> void:
	detection_area_shape.shape.radius = detection_radius

func _on_detection_area_body_entered(body:Node3D) -> void:
	if body is GrabbableObject:
		target_object = body
		state = "Get_the_item"
		destination = target_object.global_position
		_set_navigation_target()

func _on_detection_area_body_exited(body:Node3D) -> void:
	if body == target_object:
		target_object = null
		state = "Lost item"


func _physics_process(_delta: float) -> void:
	if nav.is_navigation_finished():
		if state == "Get_the_item":
			target_object.get_grabbed()
			state = "Stolen_item"
			_set_exit()
		else:
			_fade_out()

	var next_path_position: Vector3 = nav.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	nav.set_velocity(new_velocity)
