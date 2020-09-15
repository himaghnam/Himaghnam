extends Node2D

var Score:int = 1000
var Gold_coin:int = 2000

var Current_Health:int 
var Current_Mana:int 

var Weapon_Damage:int = 1000

var Current_level:int = 5
var Level_Unlocked:Dictionary ={"1":{"Unlocked":true,"Stars": 0}}

var Player_data_dict:Dictionary = {
		"current_saved_scene": "user://saved1.tscn",
		"Health":Current_Health,
		"Mana":Current_Mana,
		"Gold":Gold_coin,
		"Score":Score,
		"Weapon_Damage":Weapon_Damage,
		"Unlocked_levels":Level_Unlocked}

func _ready() -> void:
#	_save_game()
	$State_run.hide()
	_save_scene()
	
func _save_game() -> void:
	Player_data_dict = {
		"current_saved_scene": "user://saved1.tscn",
		"Health":Current_Health,
		"Mana":Current_Mana,
		"Gold":Gold_coin,
		"Score":Score,
		"Weapon_Damage":Weapon_Damage,
		"Unlocked_levels":Level_Unlocked}
	var save_game = File.new()
	save_game.open("user://savegame.json", File.WRITE)
#	save_game.open_encrypted_with_pass("user://savegame.json", File.WRITE,OS.get_unique_id())
	var dict:Dictionary = Player_data_dict
	save_game.store_line(to_json(dict))
	save_game.close()
	pass

func _load_game()-> void:
	var dir:Directory = Directory.new()
	var save_game = File.new()
	if dir.file_exists("user://savegame.json"):
		save_game.open_encrypted_with_pass("user://savegame.json", File.READ,OS.get_unique_id())
		var saved1:Dictionary =  parse_json(save_game.get_as_text())
		save_game.close()
		Current_Health = int(saved1.Health)
		Current_Mana = int(saved1.Mana)
		Score = int(saved1.Score)
		Gold_coin =int(saved1.Gold)
		Weapon_Damage = int(saved1.Weapon_Damage)
		Level_Unlocked = Dictionary(saved1.Unlocked_levels)


func _save_scene()->void:
	var packed_s:PackedScene = PackedScene.new()
	var dir:Directory = Directory.new()

	packed_s.pack(get_tree().get_current_scene())
	if dir.file_exists("res://saved1.tscn"):
		dir.remove("res://saved1.tscn")
	print("scene saved")
	ResourceSaver.save("res://saved1.tscn",packed_s)
