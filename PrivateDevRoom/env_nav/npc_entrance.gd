class_name NpcEntrance
extends Marker3D


@export var available_npcs : Array[PackedScene] = [
    preload("res://PrivateDevRoom/env_nav/test_npc.tscn")
]
@export var max_number_of_npcs : int = 5
@export var max_spawn_wait_time : float = 3.0
@export var min_spawn_wait_time : float = 1.0


@onready var spawn_timer = %SpawnTimer


func _ready() -> void:
    spawn_timer.timeout.connect(_spawn_npc)
    _reset_self()

func _spawn_npc():
    """
    Spawns a new NPC if the maximum number of NPCs has not been reached.
    """
    if get_child_count() >= max_number_of_npcs - 1:
        return

    var npc = available_npcs[randi() % available_npcs.size()].instantiate()
    add_child(npc)
    _reset_self()

func _reset_self():
    """
    Resets the spawn timer to schedule the next NPC spawn.
    """
    spawn_timer.wait_time = randf_range(min_spawn_wait_time, max_spawn_wait_time)
    spawn_timer.start()
