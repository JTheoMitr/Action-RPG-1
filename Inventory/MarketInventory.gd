extends Node2D

const CashSound = preload("res://Music and Sounds/CashRegisterSound.tscn")
const BuzzerSound = preload("res://Music and Sounds/BuzzerSound.tscn")

onready var redPopButton = $Control/CenterContainer/VBoxContainer/Button
onready var coinLabel = $Control/CoinTextLabel
onready var grooves = $BossaNova

var stats = PlayerStats

func _ready():
	grooves.play(0.0)
	print_debug(get_parent())
	
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
	hide()
	grooves.stop()
	stats.emit_signal("player_resumed")
	WorldStats.emit_signal("fade_music_in")


func _on_Timer_timeout():
	self.call_deferred("queue_free")
