extends Control

var isOpen = false
var inventory = []

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	isOpen = !isOpen
	visible = isOpen

func insert_item(item: String) -> void:
	if inventory.size() < 4: # Limit inventory size if needed
		inventory.append(item)
		update_inventory_display()
	else:
		print("Inventory is full!")

func update_inventory_display():
	for i in range(inventory.size()):
		print("Slot", i + 1, ":", inventory[i])
