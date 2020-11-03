extends Node

var Inventory:Array = []
var max_item_stack:int = 20
var Item_stackable:bool = false
# warning-ignore:unused_signal
signal Item_added

func _ready() -> void:
	pass # Replace with function body.


func _Add_Item(item:PackedScene, amount:int, Item_Details:Dictionary):

	var dict:Dictionary = {"item" : null , "amount" : 0 ,"Item_Details":null} 

	if !Item_stackable : 
		if Inventory.size() != 0:
			for i in range(Inventory.size()):
				if(Inventory[i].item == item):
					Inventory[i]["amount"] += amount
#					print(Inventory)
					return
		dict["item"] = item
		dict["amount"] = amount
		dict["Item_Details"] = Item_Details
		Inventory.append(dict)
		emit_signal("Item_added")
#		print(Inventory)
		return
		
	if(Inventory.size() == 0 and amount <= max_item_stack):
		dict["item"] = item
		dict["amount"] = amount
		dict["Item_Details"] = Item_Details
		Inventory.append(dict)
		emit_signal("Item_added")
#		print(Inventory)
		return
		
		
	elif(Inventory.size() == 0 and amount > max_item_stack):
# warning-ignore:unused_variable
# warning-ignore:integer_division
		for i in range(amount/max_item_stack):
			dict["item"] = item
			dict["amount"] = max_item_stack
			dict["Item_Details"] = Item_Details
			Inventory.append(dict)
			
		if(amount % max_item_stack > 0):
			var dict_next:Dictionary = {"item" : null , "amount" : 0, "Item_Details":null } 
			dict_next["item"] = item
			dict_next["amount"] = (amount % max_item_stack )
			dict_next["Item_Details"] = Item_Details
			Inventory.append(dict_next)
		emit_signal("Item_added")
#		print(Inventory)
		return
	
	
	
	for i in range(Inventory.size()):
		if(Inventory[i].item == item):
			if ((Inventory[i].amount + amount) <= max_item_stack ):
				Inventory[i]["amount"] += amount
				emit_signal("Item_added")
#				print(Inventory)
				return
			
			if((Inventory[i]["amount"] + amount) > max_item_stack and Inventory[i]["amount"] != max_item_stack):
				
				
# warning-ignore:unused_variable
				for y in range(((Inventory[i]["amount"] + amount)/max_item_stack)):
					dict["item"] = item
					dict["amount"] = max_item_stack
					dict["Item_Details"] = Item_Details
					
					Inventory.append(dict) 
				
				if((Inventory[i]["amount"] + amount) % max_item_stack != 0):
					var dict_next:Dictionary = {"item" : null , "amount" : 0 ,"Item_Details": null} 
					dict_next["item"] = item
					dict_next["amount"] = ((Inventory[i]["amount"] + amount) % max_item_stack )
					dict_next["Item_Details"] = Item_Details
					Inventory.append(dict_next)
				Inventory.remove(i)
				emit_signal("Item_added")
#				print(Inventory)
				return
	
	#New Item
	
	if(amount <= max_item_stack):
		dict["item"] = item
		dict["amount"] = amount
		dict["Item_Details"] = Item_Details
		Inventory.append(dict)
		emit_signal("Item_added")
#		print(Inventory)
		return
		
	elif( amount > max_item_stack):
# warning-ignore:unused_variable
# warning-ignore:integer_division
		for i in range(amount/max_item_stack):
			dict["item"] = item
			dict["amount"] = max_item_stack
			dict["Item_Details"] = Item_Details
			Inventory.append(dict)
			
		if(amount % max_item_stack > 0):
			var dict_next:Dictionary = {"item" : null , "amount" : 0,"Item_Details":null } 
			dict_next["item"] = item
			dict_next["amount"] = (amount % max_item_stack)
			dict_next["Item_Details"] = Item_Details
			Inventory.append(dict_next)
		emit_signal("Item_added")
#		print(Inventory)
		return
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_accept") :
		if Inventory.size() != 0:
			for i in range(Inventory.size()):
				print(Inventory[i])
	if event is InputEventKey and event.is_action_pressed("ui_up"):
		if Inventory.size() != 0:
			for i in range(Inventory.size()):
				
				var instance= Inventory[i]["item"].instance()
				instance._eat()
		
