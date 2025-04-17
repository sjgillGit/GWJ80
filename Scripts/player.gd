class_name PlayerController

extends CharacterBody3D

#Variables exported to editor
@export_group("Movement")
@export var max_speed: float = 5.0
@export var acceleration: float = 10.0
@export var breaking: float = 10.0
@export var air_acceleration: float = 5.0
@export var jump_velocity: float = 5.0
@export var gravity_mod: float = 1.5
@export var max_run_speed: float = 20.0

var is_running: bool = false

@export_group("Camera")
@export var look_sensitivity: float = 0.005
var camera_look_input: Vector2

@export_group("Grab Items Settings")
@export var max_grab_distance: float = -15.0
@export var min_grab_distance: float = -5.0
@export var default_grab_distance: float = -4.0
@export var current_hold_distance: float = default_grab_distance
@export var pickup_mass_limit : float = 50.0
@export var ray : RayCast3D

var object_to_grab : InteractableObject :
		set(new_object):
			if !carrying_object:
				if object_to_grab:
					object_to_grab.change_outline_color(Color.BLACK)
				if new_object:
					if new_object is GrabbableObject:
						if new_object.mass > pickup_mass_limit:
							new_object.change_outline_color(Color.DARK_RED)
						else:
							new_object.change_outline_color(Color.DARK_GREEN)
					elif new_object is PocketableObject:
						new_object.change_outline_color(Color.DARK_CYAN)
				object_to_grab = new_object

var carrying_object: GrabbableObject

# Assigned when node is initialized
@onready var camera: Camera3D = get_node("Camera3D")
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_mod
@onready var player_animation: AnimationPlayer = get_node("Player_model/AnimationPlayer")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if ray:
		ray.player = self

#Called every physics frame
func _process(delta):
	#Handle movement animations
	handle_movement_animations()

	#Movement relative to mouse direction
	move_relative_to_mouse(delta)

	#Camera Look
	camera_look()

	#Implements Jump and apply gravity
	define_jumping(delta)
	
	#Apply bind to show mouse cursor
	esc_to_show_mouse()
	
	#Apply grabbing items mechanic
	process_grabbed_object()

#region Player movement

func handle_movement_animations():
	# If the animation player isn't playing a non-movement animation
	if carrying_object || player_animation.current_animation == "Drop_down":
		return

	if is_running:
		player_animation.play("Run")
		return
	elif Input.get_vector("move_left", "move_right", "move_forward", "move_backwards").is_zero_approx():
		player_animation.play("Idle")
		return
	else:
		player_animation.play("Walk")
		return


func move_relative_to_mouse(delta: float):
	var move_input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var move_direction: Vector3 = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()

	var target_speed: float = move_or_run(move_input.y)

	var current_smoothing: float = acceleration

	if not is_on_floor():
		current_smoothing = air_acceleration
	elif not move_direction:
		current_smoothing = breaking

	var target_velocity: Vector3 = move_direction * target_speed

	velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)

	move_and_slide()

func move_or_run(y_pos: float) -> float:
	var speed: float = max_speed
	is_running = Input.is_action_pressed("run")
	
	if y_pos < 0 and is_running and is_on_floor():
		speed = max_run_speed
	
	return speed

func camera_look():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		return
		
	rotate_y(-camera_look_input.x * look_sensitivity)

	camera.rotate_x(-camera_look_input.y * look_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)

	camera_look_input = Vector2.ZERO

func define_jumping(delta: float):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	elif Input.is_action_just_released("jump"): 
		velocity.y *= 0.5
	
	if not is_on_floor():
		velocity.y -= gravity * delta

func esc_to_show_mouse():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_look_input = event.relative * look_sensitivity
#endregion

#region Player Object Grabbing
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("grab_item"):
			if carrying_object:
				drop_grabbable_object()
			else:
				if object_to_grab and object_to_grab is GrabbableObject and \
					object_to_grab.mass <= pickup_mass_limit:
					grab_grabbable_object(object_to_grab)
				elif object_to_grab is PocketableObject:
					grab_pocket_item(object_to_grab)
		elif event.is_action_pressed("drop_pocket_item"):
			drop_pocket_item()
	elif event is InputEvent:
		# Sets the distance of the grabbed object based on mouse wheel scroll
		detect_scroll_to_set_distance(event)
		

func drop_grabbable_object():
	carrying_object.get_dropped()
	carrying_object.self_drop.disconnect(drop_grabbable_object)
	carrying_object.can_sleep = true
	carrying_object = null

	# Resets holding distance
	current_hold_distance = default_grab_distance

	player_animation.play("Drop_down")

func grab_grabbable_object(to_grab : GrabbableObject):
	to_grab.get_grabbed()
	carrying_object = to_grab
	to_grab.can_sleep = false
	to_grab.self_drop.connect(drop_grabbable_object)

	# Resets holding distance
	current_hold_distance = -camera.global_position.distance_to(carrying_object.global_position)

	player_animation.play("Pick_up")

func process_grabbed_object():
	if carrying_object:
		carrying_object.move_bubble(
			camera.global_transform.origin + \
			camera.global_transform.basis.z * current_hold_distance
			)

func grab_pocket_item(item : PocketableObject):
	item.grab_in_pocket()

func drop_pocket_item():
	var item : PocketableObject # get from UI from selected slot.
		#If no slot selected - try dropping slot 1 (default slot)
	if item:
		item.enable_existance(self)

func detect_scroll_to_set_distance(event: InputEvent) -> void:
	var new_grab_distance: float
	# TODO: check why mouse wheel scroll up always drops objects
	if event.is_action_released("mouse_wheel_up"):
		new_grab_distance = current_hold_distance - 0.5

		if new_grab_distance >= max_grab_distance:
			current_hold_distance = max_grab_distance
		else:
			current_hold_distance = new_grab_distance	
	elif event.is_action_released("mouse_wheel_down"):
		new_grab_distance = current_hold_distance + 0.5

		if new_grab_distance <= min_grab_distance:
			current_hold_distance = min_grab_distance
		else:
			current_hold_distance = new_grab_distance
#endregion
