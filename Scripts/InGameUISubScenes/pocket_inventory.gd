class_name PocketInventory
extends PanelContainer

@export var pockets_amount : int = 10:
	set(new_amount):
		if new_amount < min_pockets:
			new_amount = min_pockets
		elif new_amount > max_pockets:
			new_amount = max_pockets
		
		if new_amount > pockets_amount:
			pockets_amount = new_amount
			_expand_pockets()
		elif new_amount < pockets_amount:
			pockets_amount = new_amount
			_shrink_pockets()
@export var min_pockets : int = 1
@export var max_pockets : int = 10


@export_group("Internal connections")
@export var pockets : Array[PocketSlot] # Slot0 should be connected
@export var pockets_container : GridContainer

var new_slot_name_prefix : String = "Slot"

# Accepts PocketableItems
# PocketableItems should have pocket_icon (~64x64 texture)

func _ready() -> void:
	_expand_pockets()

func _expand_pockets() -> void:
	for i in pockets_amount - pockets.size():
		var new_pocket = pockets[0].duplicate()
		new_pocket.name = new_slot_name_prefix + str(pockets.size())
		pockets.append(new_pocket)
		pockets_container.add_child(new_pocket)
		new_pocket.selected = false

func _shrink_pockets() -> void:
	for i in pockets.size() - pockets_amount:
		var pocket_to_remove : Container = pockets.pop_back()
		pocket_to_remove.queue_free()

func select_next_pocket() -> void:
	if pockets.size() > 1:
		for i in pockets.size():
			if pockets[i].selected:
				pockets[i].selected = false
				if i == pockets.size() - 1:
					pockets[0].selected = true
					return
				else:
					pockets[i+1].selected = true
					return
	# none of pockets selected, select first pocket
	pockets[0].selected = true

func select_previous_pocket() -> void:
	if pockets.size() > 1:
		for i in pockets.size():
			if pockets[i].selected:
				pockets[i].selected = false
				if i == 0:
					pockets[pockets.size() - 1].selected = true
					return
				else:
					pockets[i-1].selected = true
					return
	# none of pockets selected, select first pocket
	pockets[0].selected = true

func drop_item_in_selected_slot():
	for pocket in pockets:
		if pocket.selected:
			if pocket.stored_item != null:
				return pocket.give_item()
			return null

func collect_item(item_to_collect : PocketableObject) -> bool :
	for pocket in pockets:
		if pocket.stored_item == null:
			pocket.take_item(item_to_collect)
			return true
	return false
