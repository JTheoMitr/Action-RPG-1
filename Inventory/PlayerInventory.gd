extends Node2D

onready var redPop = $Control/CenterContainer/HBoxContainer/VBoxContainer/Button/RPOPQ
onready var bluePop = $Control/CenterContainer/HBoxContainer/VBoxContainer/Button2/BPOPQ
onready var description = $Control/CenterContainer/HBoxContainer/Panel/ItemDescription

onready var cellKeyText = $Control/CenterContainer/HBoxContainer/Panel/CellKeyText
onready var animalsText = $Control/CenterContainer/HBoxContainer/Panel/AnimalsText
onready var exitKey = $Control/CenterContainer/HBoxContainer/Panel/ExitKey

onready var cellCheck = $Control/CenterContainer/HBoxContainer/Panel/CellCheckSprite
onready var cellCheckTwo = $Control/CenterContainer/HBoxContainer/Panel/CellCheckSprite2
onready var cellCheckThree = $Control/CenterContainer/HBoxContainer/Panel/CellCheckSprite3
onready var switchText = $RichTextLabel2
onready var stats = PlayerStats
onready var worldStats = WorldStats
onready var controlsPanel = $ControlsPanel

const ItemFocusSound = preload("res://Music and Sounds/ItemFocusSound.tscn")
const ItemSelectSound = preload("res://Music and Sounds/MenuSelectSound.tscn")

var menuOn = false
var controlsOn = false


func _ready():
	cellCheck.hide()
	cellCheckTwo.hide()
	cellCheckThree.hide()
	controlsPanel.hide()
	
func _process(_delta):
	if Input.is_action_just_pressed("laser"):
		hide()
		controlsPanel.hide()
		get_tree().paused = false
		menuOn = false
	if Input.is_action_just_pressed("special_one"):
		if controlsOn:
			controlsPanel.hide()
			controlsOn = false
			switchText.text = "Controls"
		elif !controlsOn:
			controlsPanel.show()
			controlsOn = true
			switchText.text = "Inventory"
		
	redPop.text = str(stats.redpops)
	bluePop.text = str(stats.bluepops)
	
	if stats.keys_collected == 1:
		cellKeyText.text = "- Find 3 Cell Keys (1/3)"
	elif stats.keys_collected == 2:
		cellKeyText.text = "- Find 3 Cell Keys (2/3)"
	elif stats.keys_collected == 3:
		cellKeyText.text = "- Find 3 Cell Keys"
		cellCheck.show()
		
	if worldStats.freed == 1:
		animalsText.text = "- Free Animals (1/3)"
	elif worldStats.freed== 2:
		animalsText.text = "- Free Animals (2/3)"
	elif worldStats.freed == 3:
		animalsText.text = "- Free Animals"
		cellCheckTwo.show()
		
	if stats.boss_keys >= 1:
		cellCheckThree.show()
		

func focused():
	var ifSound = ItemFocusSound.instance()
	get_tree().current_scene.add_child(ifSound)
	
func selected():
	var ifSelect = ItemSelectSound.instance()
	get_tree().current_scene.add_child(ifSelect)

func _on_Button_pressed(): #redpop
	if stats.redpops >= 1 && stats.health < stats.max_health:
		stats.health += 2
		stats.redpops -= 1
		selected()


func _on_Button_focus_entered():
	description.bbcode_text = "[right] +2 Health [/right]"
	if menuOn == true:
		focused()


func _on_Button2_focus_entered():
	description.bbcode_text = "[right] +1 Energy [/right]"
	focused()
	menuOn = true


func _on_Button3_focus_entered():
	description.bbcode_text = "[right] Full Health / Energy [/right]"
	focused()




func _on_Button2_pressed(): #bluepop
	if stats.bluepops >= 1 && stats.batteries < stats.max_batteries:
		stats.batteries += 1
		stats.bluepops -= 1
		selected()


func _on_Button3_pressed():
	pass # Replace with function body.
