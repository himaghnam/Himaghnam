extends Position2D

var loot_randamizer : RandomNumberGenerator = RandomNumberGenerator.new()
onready var coin = preload("place your coin loot scene node")

func _ready() -> void:
	_drop_loot_tier_1()

func _drop_loot_tier_1():
	loot_randamizer.randomize()
	var loot_percent:int = loot_randamizer.randi_range(0,100)
	
	if loot_percent >= 0:
# warning-ignore:unused_variable
		for i in range(loot_randamizer.randi_range(1,6)):
			var coin_instance:RigidBody2D = coin.instance()
			add_child(coin_instance)
		
		if loot_percent >= 20:
			print("2")
		
			if loot_percent >= 40:
				print("3")
			
				if loot_percent >= 60:
					print("4")
				
					if loot_percent >= 80:
						print("5")
