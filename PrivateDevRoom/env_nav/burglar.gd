class_name BurglarNpc
extends default_npc_nav


@export_enum("Idle","MoveToRoom", "Get_the_item", 
"Stolen_item", "Lost_item", "Exiting") var state : String
@export var detection_radius : float = 10

@onready var detection_area : Area3D = $DetectionArea
@onready var detection_area_shape : CollisionShape3D = $DetectionArea/DetectionShape
@onready var timer = $Timer

@export var target_destination : Marker3D

var target_object : GrabbableObject

func _ready() -> void:
	detection_area_shape.shape.radius = detection_radius
	state = "Idle"

func _on_detection_area_body_entered(body:Node3D) -> void:
	if body is GrabbableObject:
		var current_agent_position: Vector3 = global_position
		destination = current_agent_position
		timer.start(2)
		await timer.timeout
		_set_navigation_target()
		target_object = body
		state = "Get_the_item"

func _on_detection_area_body_exited(body:Node3D) -> void:
	if body == target_object:
		target_object = null
		state = "Lost item"

func _physics_process(_delta: float) -> void:
	match state:
		"Idle":
			process_idle()
		"MoveToRoom":
			process_move_to_room()
		"Get_the_item":
			process_get_item()
		"Stolen_item":
			process_stolen_item()
		"Lost_item":
			process_lost_item()
		"Exiting":
			process_exiting()
		_:
			push_error("Unknown state")
	#if state == "Idle":
		#_set_navigation_target()
		#var next_path_position: Vector3 = nav.get_next_path_position()
		#var current_agent_position: Vector3 = global_position
		#var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
		#nav.set_velocity(new_velocity)
	#if state == "NightIdle":
		#pass
	#if nav.is_navigation_finished():
		#if state == "Get_the_item":
			#target_object.get_grabbed()
			#if target_object.is_grabbed:
				#_set_exit()
			#state = "Stolen_item"
			#_set_exit()
		#elif state == "Exiting":
			#_set_exit()

	#var next_path_position: Vector3 = nav.get_next_path_position()
	#var current_agent_position: Vector3 = global_position
	#var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	#nav.set_velocity(new_velocity)

func process_idle():
	destination = target_destination.global_position
	state = "MoveToRoom"
	
func process_move_to_room():
	if nav.is_navigation_finished():
		state = "Idle"
	else:
		move()
	
func process_get_item():
	destination = target_object.global_position
	_set_navigation_target()
	move()
	
func process_stolen_item():
	pass
	
func process_lost_item():
	# TODO add navigation cost
	_set_exit()
	
func process_exiting():
	_set_exit()
	
func move():
	var next_path_position: Vector3 = nav.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	nav.set_velocity(new_velocity)

func _on_timer_timeout() -> void:
	print("timer wait")
	timer.stop()
