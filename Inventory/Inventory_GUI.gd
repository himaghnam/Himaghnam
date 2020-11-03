extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var visibility:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# warning-ignore:return_value_discarded
	Inventory_global.connect("Item_added",self,"_refresh")
#	_refresh()
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_I:
			visibility = !visibility
			$ItemList.visible = visibility

func _refresh()->void:
	$ItemList.clear()
	for i in range(Inventory_global.Inventory.size()):
#		print(Inventory_global.Inventory[i])
		$ItemList.add_item(Inventory_global.Inventory[i]["Item_Details"].name +
			" " + String(Inventory_global.Inventory[i].amount),
			Inventory_global.Inventory[i]["Item_Details"].icon)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

var pressed:bool =false
var pressed_index:int
var pressed_item:Dictionary
var released_index:int
var released_item:Dictionary
var pressed_icon:Sprite

func _on_ItemList_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed(): 
		pressed = true
		pressed_index = $ItemList.get_item_at_position(event.position,true)
		pressed_item = Inventory_global.Inventory[$ItemList.get_item_at_position(event.position,true)]
		pressed_icon = Sprite.new()
		pressed_icon.texture = pressed_item["Item_Details"].icon
		pressed_icon.scale = Vector2(5,5)
		pressed_icon.position = event.position
		add_child(pressed_icon)
	if event is InputEventMouseButton and !event.is_pressed():
		pressed = false
		remove_child(pressed_icon)
		if released_index != -1:
			released_item = Inventory_global.Inventory[$ItemList.get_item_at_position(event.position,true)]
			Inventory_global.Inventory.remove(released_index)
			Inventory_global.Inventory.insert(released_index,pressed_item)
			Inventory_global.Inventory.remove(pressed_index)
			Inventory_global.Inventory.insert(pressed_index,released_item)
			_refresh()
	if event is InputEventMouseMotion and pressed:
		released_index = $ItemList.get_item_at_position(event.position,true)
		pressed_icon.position = event.position
		
	pass # Replace with function body.
