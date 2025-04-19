class_name DefaultNPC
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


@export var destination: Vector3:
	set(new_value):
		print(new_value)
		nav.set_target_position(new_value)
		destination = new_value
		
var exit_destination : Vector3


func _ready() -> void:
	if self is not BurglarNPC:
		_set_exit()

func _physics_process(_delta: float) -> void:
	move()
	if nav.is_navigation_finished():
		_fade_out()


func move() -> void:
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
	destination = exit_destination
