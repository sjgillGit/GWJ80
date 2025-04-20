extends Node3D

@export_group("Spawn settings")
@export var spawn_points : Array[Marker3D]
@export var max_NPC_day_count : int = 15
@export var max_NPC_night_count : int = 5
@export var max_burglar_day_count : int = 1
@export var max_burglar_night_count : int = 15
@export_subgroup("Timer settings")
@export var min_spawn_cd : float = 1.0
@export var max_spawn_cd : float = 5.0

@export_group("Spawnable NPCs")
@export var daytime_NPCs : Array[PackedScene]
@export var daytime_burglars : Array[PackedScene]
@export var nighttime_NPCs : Array[PackedScene]
@export var nighttime_burglars : Array[PackedScene]

@export_group("Internal connections")
@export var spawned_NPC_folder : Node3D
@export var spawned_Burglars_folder : Node3D
@export var spawn_timer : Timer


var is_nighttime : bool = false

func _ready() -> void:
	spawn_timer.start(0.1)
	GlobalInGame.nighttime_starts.connect(switch_to_nightmode)


func switch_to_nightmode() -> void:
	is_nighttime = true

func check_for_new_spawn() -> void:
	if is_nighttime:
		if spawned_Burglars_folder.get_child_count() < max_burglar_night_count:
			var nightBurglar : BurglarNPC = nighttime_burglars.pick_random().instantiate()
			
			
			spawned_Burglars_folder.add_child(nightBurglar)
			give_points_to_spawned(nightBurglar)
			
			return
		
		if spawned_NPC_folder.get_child_count() < max_NPC_night_count:
			var nightNPC : DefaultNPC = nighttime_NPCs.pick_random().instantiate()
			
			spawned_NPC_folder.add_child(nightNPC)
			give_points_to_spawned(nightNPC)
			nightNPC.update_exit_position()
			return
		
	else:
		if spawned_Burglars_folder.get_child_count() < max_burglar_day_count:
			var dayBurglar : BurglarNPC = daytime_burglars.pick_random().instantiate()
			
			
			spawned_Burglars_folder.add_child(dayBurglar)
			give_points_to_spawned(dayBurglar)
			return
		
		if spawned_NPC_folder.get_child_count() < max_NPC_day_count:
			var dayNPC : DefaultNPC = daytime_NPCs.pick_random().instantiate()
			
			
			spawned_NPC_folder.add_child(dayNPC)
			give_points_to_spawned(dayNPC)
			dayNPC.update_exit_position()
			return
	


func _on_spawn_timer_timeout() -> void:
	check_for_new_spawn()
	spawn_timer.start(randf_range(min_spawn_cd, max_spawn_cd))


func give_points_to_spawned(spawned : DefaultNPC) -> void:
	spawned.global_position = spawn_points.pick_random().global_position
	spawned.exit_destination = spawn_points.pick_random().global_position
	if spawned.exit_destination == spawned.global_position and spawn_points.size():
		while spawned.exit_destination == spawned.global_position:
			spawned.exit_destination = spawn_points.pick_random().global_position
