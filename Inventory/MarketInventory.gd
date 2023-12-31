extends Node2D

const CashSound = preload("res://Music and Sounds/CashRegisterSound.tscn")
const BuzzerSound = preload("res://Music and Sounds/BuzzerSound.tscn")

onready var redPopButton = $Control/CenterContainer/VBoxContainer/Button
onready var coinLabel = $Control/CoinTextLabel
var stats = PlayerStats

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	coinLabel.text = "x " + str(stats.coins)

func _on_Button_pressed(): #redpop
	
	print(stats.coins)
	
	if stats.coins >= 5:
		stats.redpops += 1
		stats.coins -= 5
		var cashSound = CashSound.instance()
		get_tree().current_scene.add_child(cashSound)
	else:
		var buzzerSound = BuzzerSound.instance()
		get_tree().current_scene.add_child(buzzerSound)
		

func _on_Button2_pressed(): #bluepop
	
	if stats.coins >= 5:
		stats.bluepops += 1
		stats.coins -= 5
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
	stats.emit_signal("player_resumed")
