class_name GrabbableItem

extends InteractableItem

@export var weight: float = 0.0
# Durability should be changed from external scripts
@export var durability: float:
	get:
		return durability
	set(durability_in):
		durability = durability_in
		print("Durability has changed")
@export var value: float = 0.0:
	get:
		return value
	set(value_in):
		value = value_in
@export var obj_name: String = "placeholder":
	get:
		return obj_name
	set(name_in):
		obj_name = name_in

# Can object be pocketed
@export var pocketable: bool:
	get:
		return pocketable
	set(pocketable_in):
		pocketable = pocketable_in
		
var is_grabbed: bool = false:
	get:
		return is_grabbed
	set(grabbed_in):
		is_grabbed = grabbed_in

func _physics_process(delta: float) -> void:
	pass

func obj_pickup() -> void:
	pass

func obj_highlight() -> void:
	pass

func take_damage(damage_val: float) -> void:
	var dur = get("durability")
	if damage_val >= dur:
		set("durability", 0.0)
		queue_free()
	else:
		dur -= damage_val
		set("durability", dur)
