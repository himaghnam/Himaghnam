extends Node2D


var direction:int 
var speed:float = 50
var mana_cost:int = 5

func _ready() -> void:
	Global.Mana -= mana_cost
	Global.emit_signal("update_mana")


func _physics_process(delta: float) -> void:
	position.x += (direction*speed*delta)



func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		#do damage
		#do animation
		self.queue_free()
	pass # Replace with function body.


func _on_Timer_timeout() -> void:
	self.queue_free()
	pass # Replace with function body.
