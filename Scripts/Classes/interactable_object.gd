class_name InteractableObject
extends RigidBody3D

@export_group("Object settings")
@export var listed_name : String = ""
@export var value : int = 10000
@export_range(0, 100, 0.1) var durability : float = 100:
	set(new_value):
		new_value = clampf(new_value, 0.0 , 100.0)
		report_value_loss(roundi(
			value * (durability - new_value) / 100
		))
		durability = new_value
		
@export_range(0.01, 100, 0.01) var fragility : float = 1
@export_enum(
	"res://Assets/SFX/clang 1.wav",
	"res://Assets/SFX/clang 2.wav",
	"res://Assets/SFX/flam clang 1.wav",
	"res://Assets/SFX/flam clang 2.wav",
	"res://Assets/SFX/jangle clank 1.wav",
	"res://Assets/SFX/jangle clank 2.wav",
	"res://Assets/SFX/plastic pipe 1.wav",
	"res://Assets/SFX/plastic pipe 2.wav",
	"res://Assets/SFX/rubber slip 1.wav",
	"res://Assets/SFX/rubber slip 2.wav",
	"res://Assets/SFX/shatter 1.wav",
	"res://Assets/SFX/shatter 2.wav",
	"res://Assets/SFX/thump 1.wav",
	"res://Assets/SFX/thump 2.wav",
) var damage_sound = "res://Assets/SFX/thump 1.wav"

@export_group("Internal connections")
@export var mesh : MeshInstance3D
@export var collision_shape : CollisionShape3D

# Because sounds are not being preloaded due to the enum
var preloaded_sound : AudioStreamWAV

var collision_spam_prevention_timer : Timer = Timer.new()
# Tracking real velocity
var _last_position : Vector3 = Vector3.ZERO
var real_velocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	# Preload damage sound
	preloaded_sound = load(damage_sound)
	# make outline unique
	if mesh and mesh is MeshInstance3D and mesh.material_overlay:
		mesh.material_overlay = mesh.material_overlay.duplicate()
	# Enable RigidBody collision tracking
	set_up_inv_timer()
	#sleeping = true
	contact_monitor = true
	max_contacts_reported = 5
	if self is GrabbableObject:
		add_to_group("GrabbableObject")
	add_outline_material()
	set_collision_mask_value(4, true)

func add_outline_material():
	var outline_material = load("res://Assets/Materials/outline.tres").duplicate()
	for child in get_children():
		if child is MeshInstance3D:
			child.material_overlay = outline_material

func set_up_inv_timer() -> void:
	collision_spam_prevention_timer = Timer.new()
	collision_spam_prevention_timer.one_shot = true
	collision_spam_prevention_timer.wait_time = 0.5
	add_child(collision_spam_prevention_timer)

func change_outline_color(new_color : Color = Color.BLACK) -> void:
	for child in get_children():
		if child is MeshInstance3D:
			child.material_overlay.albedo_color = new_color

func report_value_loss(amount : int) -> void:
	GlobalInGame.item_was_damaged.emit(amount)

func _physics_process(delta: float) -> void:
	real_velocity = (global_position - _last_position) / delta
	_last_position = global_position
	if collision_spam_prevention_timer.is_stopped():
		if get_colliding_bodies().is_empty():
			return
		for body in get_colliding_bodies():
			if body is InteractableObject:
				var impact_power = (real_velocity - body.real_velocity).length()
				count_damage_from_collision(impact_power, body)
			elif body is StaticBody3D:
				var impact_power = real_velocity.length()
				count_damage_from_collision(impact_power, null)

func count_damage_from_collision(impact : float, other_body):
	if impact < 0.1:
		return
	var napkin_damage : float
	if other_body:
		napkin_damage = other_body.mass * impact / (mass * fragility)
	else:
		napkin_damage =  impact / (mass * fragility)
	if napkin_damage > 3:
		durability -= napkin_damage
		collision_spam_prevention_timer.start()
		play_damage_sound()


func play_damage_sound():
	var audio_player = AudioStreamPlayer3D.new()
	audio_player.stream = preloaded_sound
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
