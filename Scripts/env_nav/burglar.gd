class_name BurglarNPC
extends DefaultNPC

@export_enum("GetToItem" , "Wait" , "GetOutWithItem" , "GiveUp") var state : String = "GetToItem"
@export var wait_before_stealing_sec : float = 1.5
@export var time_staying_in_zone_sec : float = 30.0
@export_group("Internal connections")
@export var item_detection_area : Area3D
@export var grabbed_item_hold_position : Marker3D

var wait_timer : Timer
var patience_timer : Timer 
var gave_up : bool = false
var item_planned_to_steal : GrabbableObject :
	set(new_value):
		if new_value and new_value is GrabbableObject:
			destination = new_value.global_position
			item_names_banned_from_stealing.append(new_value.name)
		item_planned_to_steal = new_value
var backup_location_to_go : Vector3
var stolen_item : GrabbableObject = null
var item_names_banned_from_stealing : Array[String]

func _ready() -> void:
	prepare_timers()
	preplan_item_to_steal()
	state = "GetToItem"

func preplan_item_to_steal() -> void:
	var loop_prevent : int = 0
	while !item_is_ok_to_steal(item_planned_to_steal):
		if get_tree().get_nodes_in_group("GrabbableObject").is_empty():
			queue_free()
			return
		item_planned_to_steal = get_tree().get_nodes_in_group("GrabbableObject").pick_random()
		if loop_prevent > 50:
			queue_free()
			return
		loop_prevent += 1
		if item_planned_to_steal is not GrabbableObject:
			push_error("Non-grabbable object in \"GrabbableObject\" group")
	
	backup_location_to_go = item_planned_to_steal.global_position

func prepare_timers() -> void:
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	add_child(wait_timer)
	patience_timer = Timer.new()
	patience_timer.one_shot = true
	add_child(patience_timer)
	patience_timer.start(time_staying_in_zone_sec)
	patience_timer.timeout.connect(patience_time_up)

func _physics_process(delta: float) -> void:
	if global_position.y < 0:
		global_position.y = 0
	match state:
		"GetToItem":
			if gave_up:
				state = "GiveUp"
			else:
				getting_to_item()
		"Wait":
			waiting_next_to_item()
		"GetOutWithItem":
			getting_out_with_item()
		"GiveUp":
			get_out_of_level()
		_:
			push_error(self, " state machine error")

func getting_to_item() -> void:
	if item_planned_to_steal == null or item_planned_to_steal.is_queued_for_deletion():
		check_for_new_item()
		if item_planned_to_steal == null:
			destination = backup_location_to_go
		return
	
	if !item_is_ok_to_steal(item_planned_to_steal):
		check_for_new_item()
		if item_planned_to_steal == null:
			destination = backup_location_to_go
	else:
		if nav.is_navigation_finished():
			state = "Wait"
			wait_timer.start(wait_before_stealing_sec)
		else:
			move()

func waiting_next_to_item():
	if wait_timer.is_stopped():
		if item_is_ok_to_steal(item_planned_to_steal):
			stolen_item = item_planned_to_steal
			stolen_item.been_stolen = true
			#stolen_item.add_collision_exception_with(self)
			destination = exit_destination
			nav.avoidance_priority = 0.9
			state = "GetOutWithItem"
		else:
			if !gave_up:
				state = "GetToItem"
			else:
				state = "GiveUp"

func getting_out_with_item():
	move()
	if stolen_item and not stolen_item.is_grabbed:
		if nav.is_navigation_finished():
			GlobalInGame.report_stolen_item.emit(stolen_item)
			stolen_item.queue_free()
			stolen_item = null
			_fade_out()
		else:
			move_stolen_item_to_new_global_position(grabbed_item_hold_position.global_position)
	else:
		if stolen_item:
			stolen_item.been_stolen = false
			#stolen_item.remove_collision_exception_with(self)
			stolen_item = null
		nav.avoidance_priority = 0.5
		state = "GetToItem"

func move_stolen_item_to_new_global_position(new_global_postion : Vector3):
	stolen_item.global_position = new_global_postion
	stolen_item.linear_velocity = Vector3.ZERO
	stolen_item.sleeping = false

func get_out_of_level():
	move()
	if nav.is_navigation_finished():
		_fade_out()

func check_for_new_item() -> void:
	if get_tree().get_nodes_in_group("GrabbableObject").is_empty():
		state = "GiveUp"
	
	for detected_item in item_detection_area.get_overlapping_bodies():
		if detected_item is GrabbableObject and not detected_item.is_queued_for_deletion():
			evaluate_item_over_planned(detected_item)
	if !item_is_ok_to_steal(item_planned_to_steal):
		item_planned_to_steal = null

func _on_detection_area_body_entered(body: Node3D) -> void:
	if state == "GetToItem":
		if body and not body.is_queued_for_deletion():
			if body is GrabbableObject:
				if item_is_ok_to_steal(body):
					evaluate_item_over_planned(body)


func evaluate_item_over_planned(new_item) -> void:
	if !new_item: return
	if new_item is GrabbableObject:
		if !item_is_ok_to_steal(new_item):
			return
		if item_planned_to_steal:
			if new_item.value > item_planned_to_steal.value:
				item_planned_to_steal = new_item
				
		else:
			item_planned_to_steal = new_item

func item_is_ok_to_steal(item : GrabbableObject) -> bool:
	if item:
		if not (item.been_stolen or item.is_grabbed):
			return true
	return false

func patience_time_up() -> void:
	gave_up = true
	if state != "GetOutWithItem":
		state = "GiveUp"
		destination = exit_destination


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	trigger_navigation_agent_3d_velocity_computed(safe_velocity)
