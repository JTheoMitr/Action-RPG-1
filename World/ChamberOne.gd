extends StaticBody2D

const Soldier = preload("res://Enemies/Soldier.tscn")
const SoldierGreen = preload("res://Enemies/SoldierGreen.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var startFrame = random_drop_generator([0,1,2])
	$AnimatedSprite.frame = startFrame
	$AnimatedSprite.play("default")
	WorldStats.connect("chamber_one_start", self, "start_timers")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Timer_timeout():
	$Timer2.stop()
	$Timer3.stop()
	
func start_timers():
	if triggered == false:
		var soldier = SoldierGreen.instance()
		get_parent().call_deferred("add_child", soldier)
		soldier.global_position = $SpawnArea/CollisionShape2D.global_position
		$Timer.start()
		$Timer2.start()
		$Timer3.start()
		triggered = true


func _on_Timer2_timeout():
	var soldier = Soldier.instance()
	get_parent().call_deferred("add_child", soldier)
	soldier.global_position = $SpawnArea/CollisionShape2D.global_position


func _on_Timer3_timeout():
	var soldier = SoldierGreen.instance()
	get_parent().call_deferred("add_child", soldier)
	soldier.global_position = $SpawnArea/CollisionShape2D.global_position
