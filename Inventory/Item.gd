extends Area2D


export var amount:int 
export var max_stack:int 
export var stackable:bool 
export var Item_name:String 

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Item_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Inventory_global.max_item_stack = max_stack
		Inventory_global.Item_stackable = stackable
		var Item:PackedScene = load("res://"+Item_name+".tscn")
		var Item_Details:Dictionary = {"stackable":stackable,"name":Item_name,"max_stack":max_stack}
		Inventory_global._Add_Item(Item,amount,Item_Details)
		Inventory_global.emit_signal("Item_added")
		queue_free()
	pass # Replace with function body.

func _eat()->void:
	print("eat")
