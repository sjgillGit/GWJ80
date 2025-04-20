class_name DefaultNPC
extends CharacterBody3D


@export var speed : float = 4.0:
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
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var destination: Vector3:
	set(new_value):
		nav.set_target_position(new_value)
		destination = new_value
		
var exit_destination : Vector3

func _ready() -> void:
	GlobalInGame.NPC_Array.append(self)

func update_exit_position():
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
	look_at((-new_velocity + global_position) * Vector3(1,0,1))
	nav.set_velocity(new_velocity)
	

func _fade_out() -> void:
	GlobalInGame.NPC_Array.erase(self)
	queue_free()

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	trigger_navigation_agent_3d_velocity_computed(safe_velocity)

func trigger_navigation_agent_3d_velocity_computed(safe_velocity : Vector3) -> void:
	velocity = safe_velocity
	var ven_len = velocity.length() 
	if ven_len == 0:
		animation_player.play("Idle")
	elif ven_len > 5:
		animation_player.play("Running")
	else:
		animation_player.play("Walking")
	animation_player.speed_scale = safe_velocity.length() * 0.6
	move_and_slide()

func _set_exit():
	destination = exit_destination
