extends CharacterBody3D

@export var speed : float = 2.0:
	get:
		return speed
	set(speed_in):
		speed = speed_in
@export var accel : float = 10.0:
	get:
		return accel
	set (accel_in):
		accel = accel_in
var holding_object: bool = false:
	get:
		return holding_object

# These values are for determining semi-random positions in the level for pathfinding
@export var lower_x : float = 0.0
@export var lower_y : float = 0.0
@export var lower_z : float = 0.0
@export var upper_x : float = 0.0
@export var upper_y : float = 0.0
@export var upper_z : float = 0.0

# Value for number of locations npc spawned will want to walk towards
@export var number_of_locations : int = 0

# This is mainly for testing purposes, unless we want npc to only go towards one location
@export var destination: Vector3 = Vector3.ZERO

# Navigation agent
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var paths = []

# The purpose is to get random range of coordinates npc wants to go towards
func set_random_path_list() -> Array:
	var path_list = []
	if number_of_locations <= 0:
		push_error("Number of locations must be greater than zero.")
		return path_list

	for i in range(number_of_locations):
		if lower_x >= upper_x or lower_y >= upper_y or lower_z >= upper_z:
			push_error("Lower bounds must be less than upper bounds.")
			return path_list

		var x = randf_range(lower_x, upper_x)
		var y = randf_range(lower_y, upper_y)
		var z = randf_range(lower_z, upper_z)
		path_list.append(Vector3(x, y, z))
	
	return path_list

func _ready() -> void:
	set_random_path_list()

func _physics_process(delta: float) -> void:
	nav.set_target_position(destination)
	var dest = nav.target_position
	var local_destination = dest - global_position
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	if not holding_object:
		velocity = (direction * speed * accel) * delta
	else:
		velocity = (direction * speed) * delta	
	move_and_slide()
