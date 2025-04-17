extends Node

var van_objects:Array[GrabbableObject] = []

@export_group("Voxel Tiles Settings")
@export var tile_map:GridMap
@export var placement_area: Area3D

@export_group("Player Collision Detection")
# Reference for delivery place
@export var collision_shape: MeshInstance3D

func _ready():
	print(placement_area.get_overlapping_bodies())
	# define_voxel_cells()
	

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is PlayerController and body.carrying_object != null:
		collision_shape.material_override.albedo_color.a = 0.125


func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is PlayerController:
		collision_shape.material_override.albedo_color.a = 0.01

func define_voxel_cells():
	var aabb:AABB = placement_area.get_child(0).get_aabb()

	print(aabb)
