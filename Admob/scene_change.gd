extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ads.connect("interstitial_closed",self,"unpause")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.is_pressed():
		print("s")
		if get_viewport().has_node("Scene_1") :
			if Ads.is_interstitial_loaded():
				Ads.show_interstitial()
				get_tree().change_scene("res://Scene_2.tscn")
				get_tree().paused = true
			
		if get_viewport().has_node("Scene_2") :
			get_tree().change_scene("res://Scene_1.tscn")

func unpause():
	get_tree().paused = false
