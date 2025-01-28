extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var dent = $Dent
onready var openTrunk = $OpenTrunk
onready var tink = $Tink

const XpOrb = preload("res://Enemies/XpOrb.tscn")
const HeadlightEffect = preload("res://Effects/HeadlightEffect.tscn")
const HitEffect = preload("res://Effects/HitEffect.tscn")

var opened
var dented
# Called when the node enters the scene tree for the first time.
func _ready():
	dent.hide()
	openTrunk.hide()
	opened = false
	dented = false

func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_pos(value):
	var numberX = random_drop_generator([6, 7, 8])
	var numberY = random_drop_generator([5, 6, 7])
	value.global_position.x = global_position.x + numberX
	value.global_position.y = global_position.y + numberY
	
	
func _on_Hurtbox_area_entered(area):
	if opened == false:
		if dented:
			print_debug("opening")
			dent.hide()
			openTrunk.show()
			var headlightEffect = HeadlightEffect.instance()
			get_parent().add_child(headlightEffect)
			headlightEffect.global_position.x = global_position.x + 3
			headlightEffect.global_position.y = global_position.y + 4
			
			var xp = XpOrb.instance()
			get_parent().call_deferred("add_child", xp)
			call_deferred("set_pos", xp)
			opened = true
		else:
			dent.show()
			dented = true
			tink.play()
			var effect = HitEffect.instance()
			var main = get_tree().current_scene
			main.add_child(effect)
			effect.global_position.x = global_position.x
			effect.global_position.y = global_position.y + 9
