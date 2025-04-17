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

@export var destination: Vector3 = Vector3.ZERO
		
@onready var nav: NavigationAgent3D = $NavigationAgent3D
		
# For testing, reapply destination with random value - remove before merging with player scripts
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		var random_position = Vector3.ZERO
		random_position.x = randf_range(-10.0, 10.0)
		random_position.y = randf_range(-10.0, 10.0)
		nav.set_target_position(random_position)

func _physics_process(delta: float) -> void:
	nav.set_target_position(destination)
	var dest = nav.target_position      
	var local_destination = dest - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	move_and_slide()
