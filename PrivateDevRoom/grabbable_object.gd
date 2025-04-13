extends Node3D

@export var weight: float = 0.0
# Durability should be changed from external scripts
@export var durability: float:
	set(durability_in):
		durability = durability_in
		print("Durability has changed")
@export var value: float = 0.0
@export var obj_name: String = "placeholder"

# Can object be pocketed
@export var pocketable: bool

# Definition for what type of object this is to be
@export var obj_asset: Node3D

func _physics_process(delta: float) -> void:
	pass

func obj_pickup() -> void:
	pass
	
func obj_highlight() -> void:
	pass

func take_damage(damage_val: float) -> void:
	durability -= damage_val
