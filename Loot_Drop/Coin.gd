extends RigidBody2D


export var value:int = 5

var impluse_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	impluse_randomizer.randomize()
	var impluse:Vector2 = Vector2(impluse_randomizer.randi_range(-10,10),impluse_randomizer.randi_range(-150,-180))
	self.apply_impulse(self.position,impluse)
	


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		GlobalSingleton.Gold_coin += value
		print(GlobalSingleton.Gold_coin)
		self.queue_free()
	pass # Replace with function body.


