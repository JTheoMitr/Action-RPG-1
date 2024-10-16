extends Node2D

const CashSound = preload("res://Music and Sounds/CashRegisterSound.tscn")
const BuzzerSound = preload("res://Music and Sounds/BuzzerSound.tscn")

onready var redPopButton = $CanvasLayer/Control/CenterContainer/VBoxContainer/Button
onready var coinLabel = $CanvasLayer/Control/CoinTextLabel
onready var grooves = $BossaNova
onready var canvasLayer = $CanvasLayer
onready var save_file = SaveFile.g_data
onready var bgnd = $CanvasLayer/Control/BGND
onready var timer1 = $Timer
onready var timer2 = $Timer2

onready var world1Bgnd = preload("res://UI/IMG_4107.JPG")
onready var world2Bgnd = preload("res://UI/IMG_4104.JPG")
onready var world3Bgnd = preload("res://UI/IMG_4113.JPG")

var stats = PlayerStats

func _ready():
	grooves.play(0.0)
	print_debug(get_parent().get_parent().get_parent().to_string()) #this is what checks for the current world node, check for World, World2, World3, etc
	if (get_parent().get_parent().get_parent()).to_string().begins_with("World:"): #try this
		bgnd.texture = world1Bgnd
	if (get_parent().get_parent().get_parent()).to_string().begins_with("World2"): #try this
		bgnd.texture = world2Bgnd
	if (get_parent().get_parent().get_parent()).to_string().begins_with("World3"): #try this
		bgnd.texture = world3Bgnd
	
func _process(delta):
	coinLabel.text = "x " + str(stats.coins)
	

func _on_Button_pressed(): #redpop
	
	print(stats.coins)
	
	if stats.coins >= 10:
		stats.redpops += 1
		stats.coins -= 10
		var cashSound = CashSound.instance()
		get_tree().current_scene.add_child(cashSound)
	else:
		var buzzerSound = BuzzerSound.instance()
		get_tree().current_scene.add_child(buzzerSound)
		

func _on_Button2_pressed(): #bluepop
	
	if stats.coins >= 10:
		stats.bluepops += 1
		stats.coins -= 10
		var cashSound = CashSound.instance()
		get_tree().current_scene.add_child(cashSound)
	else:
		var buzzerSound = BuzzerSound.instance()
		get_tree().current_scene.add_child(buzzerSound)

func _on_Button3_pressed(): #sundae
	
	if stats.coins >= 315:
		stats.bluepops += 1
		stats.coins -= 5
	else:
		var buzzerSound = BuzzerSound.instance()
		get_tree().current_scene.add_child(buzzerSound)


func _on_Button4_pressed():
	canvasLayer.hide()
	grooves.stop()
	#stats.emit_signal("player_resumed")
	WorldStats.emit_signal("fade_music_in")
	timer1.start()
	timer2.start()


func _on_Timer_timeout():
	stats.emit_signal("player_resumed")
	
	


func _on_Timer2_timeout():
	self.call_deferred("queue_free")
