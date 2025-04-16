class_name InteractableObject
extends RigidBody3D

@export_group("Object settings")
@export var value : int = 10000
@export_range(0, 100, 0.1) var durability : float = 100:
	set(new_value):
		new_value = clampf(new_value, 0.0 , 100.0)
		report_value_loss(roundi(
			value * (durability - new_value)
		))
		durability = new_value
		
@export_range(0.01, 100, 0.01) var fragility : float = 1

@export_group("Internal connections")
@export var mesh : MeshInstance3D
@export var collision_shape : CollisionShape3D

func _ready() -> void:
	# make outline unique
	if mesh and mesh is MeshInstance3D and mesh.material_overlay:
		mesh.material_overlay = mesh.material_overlay.duplicate()


func change_outline_color(new_color : Color = Color.BLACK) -> void:
	if mesh and mesh is MeshInstance3D and mesh.material_overlay:
		mesh.material_overlay.albedo_color = new_color

#TODO Connect value reporting to MVP
func report_starting_value(amount : int) -> void:
	pass

func report_value_loss(amount : int) -> void:
	pass
