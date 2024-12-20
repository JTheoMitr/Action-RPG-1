extends KinematicBody2D

const MarketInventory = preload("res://Inventory/MarketInventory.tscn")
const MarketSound = preload("res://Music and Sounds/MarketSoundOne.tscn")

onready var popup = $CanvasLayer/PopupDialog
onready var textLabel = $CanvasLayer/PopupDialog/RichTextLabel
onready var panel = $CanvasLayer/Panel
onready var sprite2 = $CanvasLayer/PopupDialog/Sprite2
onready var label = $CanvasLayer/PopupDialog/Label
onready var menuText = $CanvasLayer/PopupDialog/MenuText


var inArea = false
var textOptions = ["[center] Hey, my dude... you lookin' to \n get down on some dairy? [/center]", "[center] My frozen treats are sure to \n get you into fighting form! [/center]"]

func _ready():
	textLabel.bbcode_enabled = true
	textLabel.bbcode_text = textOptions[0]
	panel.hide()

func _process(delta):
	if (inArea == true) && (textLabel.bbcode_text == textOptions[0]):
		panel.show()
		popup.show() 
		menuText.hide()
		PlayerStats.emit_signal("player_paused")
		textLabel.bbcode_text = textOptions[0]
	if (Input.is_action_pressed("interact")) && (inArea == true):
		if textLabel.bbcode_text == textOptions[0]:
			textLabel.bbcode_text = textOptions[1]
			sprite2.hide()
			label.hide()
			menuText.show()
			$Timer.start()
	

func show_market_inventory():
	var marketInventory = MarketInventory.instance()
	var world = get_tree().current_scene
	get_parent().add_child(marketInventory)
	panel.hide()
	popup.hide()
	marketInventory.global_position.x = self.position.x - 55
	marketInventory.global_position.y = self.position.y
	

func _on_Area2D_area_entered(area):
	inArea = true
	var marketSound = MarketSound.instance()
	get_tree().current_scene.add_child(marketSound)
	WorldStats.emit_signal("fade_music_out")
	

func _on_Area2D_area_exited(area):
	inArea = false
	sprite2.show()
	label.show()
	textLabel.bbcode_text = textOptions[0]
	popup.hide()
	
	

func _on_Timer_timeout():
	show_market_inventory()

