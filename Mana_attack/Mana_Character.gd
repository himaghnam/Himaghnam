extends KinematicBody2D


var direction:int = -1
var idle:int = 0
onready var Anim = $AnimationPlayer/AnimationTree.get("parameters/playback")
onready var magic_attack_1 = preload("res://Mana_attack/Magic_1.tscn")


func _ready() -> void:
# warning-ignore:return_value_discarded
	Global.connect("update_mana",self,"_update_mana")
	
	Anim.start("idle")
	$ProgressBar.max_value = Global.Mana
	$ProgressBar.value = Global.Mana
	pass # Replace with function body.

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if idle != 0:
		Anim.travel("run")
	else:Anim.travel("idle")
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_left"):
			Anim.travel("run")
			$Player.scale.x = -1
			direction = -1
			idle = 1
		if event.is_action_pressed("ui_right"):
			Anim.travel("run")
			$Player.scale.x = 1
			direction = 1
			idle = 1
	
	if event is InputEventKey and !event.is_pressed():
		Anim.travel("idle")
		idle = 0
		
	if event is InputEventMouseButton:
		if event.is_action_pressed("ui_fire"):
			if Anim.get_current_node() != "cast":
				Anim.travel("cast")
				_mana_attack()




func _mana_attack()->void:
	var magic_attack_1_instance:Node = magic_attack_1.instance()
	if Global.Mana >= magic_attack_1_instance.mana_cost :
		magic_attack_1_instance.direction = direction
		magic_attack_1_instance.global_position = $Player/cast_position.global_position
		get_viewport().add_child(magic_attack_1_instance)

func _update_mana()->void:
	$ProgressBar.value = Global.Mana








