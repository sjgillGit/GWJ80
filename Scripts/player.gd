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
@export var grab_distance: float = -10.0

var grabbed_item: GrabbableItem

# Assigned when node is initialized
@onready var camera: Camera3D = get_node("Camera3D")
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_mod
@onready var player_animation: AnimationPlayer = get_node("Player_model/AnimationPlayer")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
	grab_items(delta)


func handle_movement_animations():
	print(player_animation.current_animation)
	# If the animation player isn't playing a non-movement animation
	if grabbed_item || player_animation.current_animation == "Drop_down":
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

func set_grabbed_item(item: GrabbableItem):
	grabbed_item = item

	# Play pick up animation
	player_animation.play("Pick_up")

func grab_items(delta: float):
	if grabbed_item != null:
		# Get target position relative to point in front of camera
		var target_position: Vector3 = camera.global_transform.origin + camera.global_transform.basis.z * grab_distance

		# TODO: implement physics based hitting object feedback
		# Smooth movement (adjust lerp speed)
		grabbed_item.global_transform.origin = grabbed_item.global_transform.origin.lerp(target_position, delta * 10)
		# Match rotation to camera
		grabbed_item.global_transform.basis = camera.global_transform.basis

func drop_item():
	# TODO: implement drop and throw force according to how long player presses the release button
	# Apply throw force using camera direction
	grabbed_item.linear_velocity = camera.global_transform.basis.z * -6
	
	# Clear reference
	grabbed_item = null

	# Play drop animation
	player_animation.play("Drop_down")
