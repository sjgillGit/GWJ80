class_name default_npc_nav
extends CharacterBody3D


@export var speed : float = 15.0:
	get:
		return speed
	set(speed_in):
		speed = speed_in
@export var accel : float = 10.0:
	get:
		return accel
	set (accel_in):
		accel = accel_in


# Navigation agent
@onready var nav: NavigationAgent3D = $NavigationAgent3D


@export var destination: Vector3 = Vector3.ZERO
var parent_entrance: Node3D
var available_points: Array[Node]

func _ready() -> void:
	parent_entrance = get_parent()
	_set_exit()

func _set_navigation_target() -> void:
	nav.set_target_position(destination)

func _physics_process(_delta: float) -> void:
	if nav.is_navigation_finished():
		_fade_out()

	var next_path_position: Vector3 = nav.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	nav.set_velocity(new_velocity)

func _fade_out() -> void:
	queue_free()

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

func _set_exit():
	available_points = get_tree().get_nodes_in_group("NPC_Entrance")
	available_points.erase(parent_entrance)
	destination = available_points[randi() % available_points.size()].global_position
	_set_navigation_target()
	
	if nav.is_navigation_finished():
		_fade_out()
