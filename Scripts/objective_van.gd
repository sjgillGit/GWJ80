extends Node3D

var van_objects: Array[GrabbableObject] = []

@onready var player_ref: PlayerController = get_tree().get_current_scene().get_node("Player")

@export_group("Player Collision Detection")
@export var collision_shape: MeshInstance3D

func generate_furniture_array_object(original_furniture: GrabbableObject):
	return original_furniture.duplicate()

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is PlayerController and body.carrying_object != null:
		collision_shape.material_override.albedo_color.a = 0.125

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is PlayerController:
		collision_shape.material_override.albedo_color.a = 0.01

func _on_placement_area_body_entered(body: Node3D) -> void:
	if body is PlayerController and body.carrying_object != null:

		var ref: GrabbableObject = generate_furniture_array_object(body.carrying_object)
		van_objects.append(ref)
		GlobalInGame.item_was_secured.emit(body.carrying_object)
		body.carrying_object.queue_free()
		body.drop_grabbable_object()
		
	elif body is GrabbableObject:
		
		var ref: GrabbableObject = generate_furniture_array_object(body)
		van_objects.append(ref)
		
		if body.is_grabbed:
			player_ref.drop_grabbable_object()
		GlobalInGame.item_was_secured.emit(body)
		body.queue_free()


#  Grid related system (DO NOT DELETE, KEEP FOR REFERENCE)
# @export_group("Voxel Tiles Settings")
# @export var gridmap:GridMap
# @export var in_van_collision_shapes_to_ignore : Array[CollisionShape3D]
# @export var in_van_collision_shape: CollisionShape3D
# func _ready():
# 	get_overlapping_active_cells()
# func get_overlapping_active_cells():
# 	for cell in gridmap.get_used_cells():
# 		var cell_center = gridmap.to_global(gridmap.map_to_local(cell))
# 		if is_point_in_collision_box(cell_center, in_van_collision_shape):
# 			var is_viable : bool = true
# 			for ignored_collision in in_van_collision_shapes_to_ignore:
# 				if is_point_in_collision_box(cell_center, ignored_collision):
# 					is_viable = false
# 			if is_viable:
# 				set_cell_as_avaliable(cell)
# 			else:
# 				set_cell_as_unavaliable(cell)
# 		else:
# 			set_cell_as_unavaliable(cell)

# func set_cell_as_avaliable(cell : Vector3i):
# 	gridmap.set_cell_item(cell, 2)

# func set_cell_as_unavaliable(cell : Vector3i):
# 	gridmap.set_cell_item(cell, 3)


# func is_point_in_collision_box(point : Vector3, area_collision : CollisionShape3D) -> bool:
# 	if !area_collision: push_error("Area doesnt have collision as child 0")
# 	if !area_collision.shape is BoxShape3D: push_error("Only BoxShape Is supported")
	
# 	var area_border_min : Vector3 = area_collision.global_position - area_collision.shape.size / 2
# 	var area_border_max : Vector3 = area_collision.global_position + area_collision.shape.size / 2
	
# 	if point.x > area_border_min.x and point.x < area_border_max.x:
# 		if point.y > area_border_min.y and point.y < area_border_max.y:
# 			if point.z > area_border_min.z and point.z < area_border_max.z:
# 				return true
# 	return false
