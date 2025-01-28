extends Node2D

const BarrelEffect = preload("res://Effects/TrashCan1Effect.tscn")
const BarrelBounce = preload("res://Effects/TrashCan1Bounce.tscn")
const Coin = preload("res://World/Coin.tscn")
const Apple = preload("res://World/Apple.tscn")

const BounceSound = preload("res://Music and Sounds/TrashCanBounceSound.tscn")
const BreakSound = preload("res://Music and Sounds/TrashCanBreakSound.tscn")
var bounced = false
var barrelBounce = BarrelBounce.instance()

func set_pos(value):
	value.global_position.x = global_position.x
	value.global_position.y = global_position.y - 1


func create_barrel_effect():
	barrelBounce.queue_free()
	var barrelEffect = BarrelEffect.instance()
	var breakAudio = BreakSound.instance()
	var bounceAudio = BounceSound.instance()
	get_parent().add_child(bounceAudio)
	get_parent().add_child(breakAudio)
	get_parent().add_child(barrelEffect)
	barrelEffect.global_position = global_position
	
func create_barrel_bounce():
	get_parent().add_child(barrelBounce)
	var bounceAudio = BounceSound.instance()
	get_parent().add_child(bounceAudio)
	barrelBounce.global_position.y = global_position.y
	barrelBounce.global_position.x = global_position.x + 3
	bounced = true
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Hurtbox_area_entered(area):
	if (bounced):
		create_barrel_effect()
		call_deferred("queue_free")
		var randomDrop = random_drop_generator(["coin", "apple",])
		if (randomDrop == "coin"):
			var coin = Coin.instance()
			get_parent().call_deferred("add_child", coin)
			call_deferred("set_pos", coin)
		elif (randomDrop == "apple"):
			var apple = Apple.instance()
			get_parent().call_deferred("add_child", apple)
			call_deferred("set_pos", apple)
			
		
	else:
		$Sprite.visible = false
		create_barrel_bounce()
		
		
	

