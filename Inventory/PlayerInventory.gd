extends Node2D

onready var redPop = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/RedPop/RPOPQ
onready var appleQ = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Apple/APQ

onready var floppy = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Floppy/FLQ
onready var description = $Control/CenterContainer/HBoxContainer/Panel/ItemDescription
onready var consumablesBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/Consumables
onready var storyItemsBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/StoryItems
onready var craftingBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/Crafting
onready var cellKeyText = $Control/CenterContainer/HBoxContainer/Panel/CellKeyText
onready var animalsText = $Control/CenterContainer/HBoxContainer/Panel/AnimalsText
onready var exitKey = $Control/CenterContainer/HBoxContainer/Panel/ExitKey
onready var redpopBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/RedPop
onready var appleBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Apple
onready var floppyBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Floppy
onready var syringeBtn = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Syringe
onready var cellCheck = $Control/CenterContainer/HBoxContainer/Panel/CellCheckSprite
onready var cellCheckTwo = $Control/CenterContainer/HBoxContainer/Panel/CellCheckSprite2
onready var cellCheckThree = $Control/CenterContainer/HBoxContainer/Panel/CellCheckSprite3
onready var exitBtn = $Control/CenterContainer/HBoxContainer/Panel/ExitButton
onready var switchText = $RichTextLabel2
onready var stats = PlayerStats
onready var worldStats = WorldStats
onready var controlsPanel = $ControlsPanel
onready var timer = $Timer
onready var levelText = $Control/CenterContainer/HBoxContainer/Panel/LevelText
onready var displayMap = $ForestWorldMap
onready var map = $Map
onready var mapButton = $MapButton
onready var mapShadow = $MapShadow
onready var popup = $PopupDialog
onready var selectedItem = $Control/CenterContainer/HBoxContainer/VBoxContainer/Panel/PSPI
onready var zipper = $Zipper

onready var aidMenu = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer
onready var storyMenu = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer2
onready var craftMenu = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer3


onready var save_file = SaveFile.g_data

const ItemFocusSound = preload("res://Music and Sounds/ItemFocusSound.tscn")
const ItemSelectSound = preload("res://Music and Sounds/MenuSelectSound.tscn")
const BagZipperSound = preload("res://Music and Sounds/PauseCloseSound.tscn")

var menuOn = false
var controlsOn = false
var mapOn = false

var pauseEnabled

# disable buttons while map or controller pane is visible
var buttonsEnabled = true

#for zipper animations:
var zipperRotate = false
var zipperRotateReverse = false
var zipperUp = false
var zipperRight = false
var zipperDown = false

var consumables
var story
var craft

func _ready():
	stats.connect("map_pickup", self, "swap_map")
	stats.connect("enable_pause", self, "free_pause")
	stats.connect("enable_pause", self, "opening")
	print_debug((get_parent().get_parent().get_parent()).to_string()) #checking for level
	if (get_parent().get_parent().get_parent()).to_string().begins_with("World:") && save_file.forestMapPickedUp: #need to add rest of maps for other levels and also check whether map was picked up for that area
		displayMap = $ForestWorldMap
	else:
		displayMap = $DefaultMap
	
	cellCheck.hide()
	cellCheckTwo.hide()
	cellCheckThree.hide()
	controlsPanel.hide()
	displayMap.hide()
	pauseEnabled = false
	
	consumables = true
	story = false
	craft = false
	
func _process(_delta):
	
	#menu management
	if consumables:
		craftMenu.hide()
		aidMenu.show()
		storyMenu.hide()
		consumablesBtn.pressed = true
		storyItemsBtn.pressed = false
		craftingBtn.pressed = false
	
	if story:
		craftMenu.hide()
		aidMenu.hide()
		storyMenu.show()
		consumablesBtn.pressed = false
		storyItemsBtn.pressed = true
		craftingBtn.pressed = false
		storyMenu.rect_global_position = aidMenu.rect_global_position
	
	if craft:
		consumablesBtn.pressed = false
		storyItemsBtn.pressed = false
		craftingBtn.pressed = true
		craftMenu.show()
		aidMenu.hide()
		storyMenu.hide()
		
	
	#zipper animation sequence
	if zipperRotateReverse:
		zipper.rotation_degrees -= .65
	if zipperRotate:
		zipper.rotation_degrees += 1
	if zipperRight:
		if zipper.position.x <= 338:
			zipper.position.x += 8
	if zipperDown:
		if zipper.position.y <= 93:
			zipper.position.y += 3
	if zipperUp:
		if zipper.position.y >= -12:
			zipper.position.y -= 7
	if (Input.is_action_just_pressed("special_one")) && self.visible:
		if controlsOn:
			controlsPanel.hide()
			controlsOn = false
			switchText.text = "Controls"
			buttonsEnabled = true
		elif !controlsOn:
			controlsPanel.show()
			controlsOn = true
			switchText.text = "Backpack"
			buttonsEnabled = false
	if (Input.is_action_just_pressed("charge_switch_f")) && self.visible:
		if mapOn == false:
			controlsPanel.hide()
			displayMap.show()
			mapOn = true
			mapButton.hide()
			mapShadow.hide()
			map.hide()
			buttonsEnabled = false
		else:
			displayMap.hide()
			controlsPanel.hide()
			mapOn = false
			controlsOn = false
			switchText.text = "Controls"
			mapButton.show()
			mapShadow.show()
			map.show()
			buttonsEnabled = true
	if (Input.is_action_just_pressed("ui_pause")):
		if pauseEnabled:
			hide()
			controlsPanel.hide()
			timer.start()
			pauseEnabled = false
	#		get_tree().paused = false
			menuOn = false
			var bagZip = BagZipperSound.instance()
			get_tree().current_scene.add_child(bagZip)
			zipper.position.x = -30
			zipper.position.y = 104
			zipper.rotation_degrees = 0
		
	redPop.text = str(stats.redpops)
	floppy.text = str(stats.bluepops)
	appleQ.text = str(stats.apples)
	levelText.text = "Level " + str(stats.level)
	
	#coloring for buttons
	if stats.redpops == 0:
		redpopBtn.modulate.r = 0.4
		redpopBtn.modulate.g = 0.4
		redpopBtn.modulate.b = 0.4
	if stats.redpops >= 1:
		redpopBtn.modulate.r = 1.0
		redpopBtn.modulate.g = 1.0
		redpopBtn.modulate.b = 1.0
		
	if stats.apples == 0:
		appleBtn.modulate.r = 0.4
		appleBtn.modulate.g = 0.4
		appleBtn.modulate.b = 0.4
	if stats.apples >= 1:
		appleBtn.modulate.r = 1.0
		appleBtn.modulate.g = 1.0
		appleBtn.modulate.b = 1.0
		
	if stats.bluepops == 0:
		floppyBtn.modulate.r = 0.4
		floppyBtn.modulate.g = 0.4
		floppyBtn.modulate.b = 0.4
	if stats.bluepops >= 1:
		floppyBtn.modulate.r = 1.0
		floppyBtn.modulate.g = 1.0
		floppyBtn.modulate.b = 1.0
	
	if save_file.key1_1_nabbed && save_file.key1_2_nabbed && save_file.key1_3_nabbed:
		cellKeyText.text = "- Find 3 Cell Keys"
		cellCheck.show() 
	elif (save_file.key1_1_nabbed && save_file.key1_2_nabbed) || (save_file.key1_2_nabbed && save_file.key1_3_nabbed) || (save_file.key1_3_nabbed && save_file.key1_1_nabbed):
		cellKeyText.text = "- Find 3 Cell Keys (2/3)"
	elif save_file.key1_1_nabbed || save_file.key1_2_nabbed || save_file.key1_3_nabbed:
		cellKeyText.text = "- Find 3 Cell Keys (1/3)"
		
		#add a get_parent() check here to determine which 'freed' animals we're checking against (forest, cave, etc)
	if displayMap == $ForestWorldMap:
		if save_file.forest_bear_saved && save_file.forest_deer_saved && save_file.forest_bunny_saved: #stats.forest_freed == 3:
			animalsText.text = "- Free Animals"
			cellCheckTwo.show()
		elif save_file.forest_bear_saved && save_file.forest_deer_saved || save_file.forest_deer_saved && save_file.forest_bunny_saved || save_file.forest_bunny_saved && save_file.forest_bear_saved: #stats.forest_freed == 2:
			animalsText.text = "- Free Animals (2/3)"
		elif save_file.forest_bear_saved || save_file.forest_deer_saved || save_file.forest_bunny_saved: #stats.forest_freed == 1:
			animalsText.text = "- Free Animals (1/3)"
		
	if save_file.boss_key_1_nabbed:
		cellCheckThree.show()
		

func focused():
	var ifSound = ItemFocusSound.instance()
	get_tree().current_scene.add_child(ifSound)
	
func selected():
	var ifSelect = ItemSelectSound.instance()
	get_tree().current_scene.add_child(ifSelect)

func opening():
	zipperRotate = true
	zipperUp = true
	yield(get_tree().create_timer(0.18), "timeout")
	zipperRotate = false
	zipperUp = false
	zipperRight = true
	yield(get_tree().create_timer(0.43), "timeout")
	zipperRight = false
	zipperDown = true
	zipperRotateReverse = true
	yield(get_tree().create_timer(0.2), "timeout")
	zipperDown = false
	zipperRotateReverse = false
	zipperRotate = true
	yield(get_tree().create_timer(0.15), "timeout")
	zipperRotateReverse = true
	zipperRotate = false
	yield(get_tree().create_timer(0.35), "timeout")
	zipperRotateReverse = false
	zipperRotate = false

func _on_Timer_timeout():
	get_tree().paused = false
	

func swap_map():
	if (get_parent().get_parent().get_parent()).to_string().begins_with("World:") && stats.forestMapFound: #need to add rest of maps for other levels and also check whether map was picked up for that area
		displayMap = $ForestWorldMap
	else:
		displayMap = $DefaultMap


func _on_PopUpButton_pressed():
	popup.hide()


func _on_QuitConfirm_pressed():
	popup.hide()
	get_tree().paused = false
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_PopUpButton_focus_entered():
	focused()


func _on_QuitConfirm_focus_entered():
	focused()

func free_pause():
	$Timer2.start()

func _on_Timer2_timeout():
	pauseEnabled = true


func _on_Syringe_focus_entered():
	description.bbcode_text = "[right] Can be used for scrap [/right]"
	selectedItem.text = "Syringe"
	focused()


func _on_RedPop_pressed(): #redpop
	if buttonsEnabled:
		if stats.redpops >= 1 && stats.health < stats.max_health:
			stats.health += 2
			stats.redpops -= 1
			selected()


func _on_RedPop_focus_entered(): #redpop
	description.bbcode_text = "[right] +2 Health [/right]"
	selectedItem.text = "Red Pop"
	if menuOn == true:
		focused()

#Menu Selections
func _on_Consumables_focus_entered():
	selectedItem.text = "Consumables"
	description.bbcode_text = "[right] Health, Energy, and Buff Items [/right]"
	consumables = true
	story = false
	craft = false
	focused()


func _on_StoryItems_focus_entered():
	selectedItem.text = "Story Items"
	description.bbcode_text = "[right] Items Required To Progress [/right]"
	consumables = false
	story = true
	craft = false
	focused()


func _on_Crafting_focus_entered():
	selectedItem.text = "Crafting"
	description.bbcode_text = "[right] Use Scrap to Craft Items and Ammo [/right]"
	focused()
	consumables = false
	story = false
	craft = true


func _on_Floppy_focus_entered():
	description.bbcode_text = "[right] +1 Energy [/right]"
	selectedItem.text = "Floppy Disk"
	focused()
	menuOn = true


func _on_Floppy_pressed():
	if buttonsEnabled:
		if stats.bluepops >= 1 && stats.batteries < stats.max_batteries:
			stats.batteries += 1
			stats.bluepops -= 1
			selected()


func _on_ExitButton_pressed():
	popup.popup()
	popup.rect_global_position.y = self.global_position.y - 10
	popup.rect_global_position.x = self.global_position.x - 50
	$PopupDialog/Sprite/HBoxContainer/PopUpButton.grab_focus()


func _on_CellKey_focus_entered():
	description.bbcode_text = "[right] opens cell door [/right]"
	selectedItem.text = "Cell Key"
	focused()


func _on_Apple_focus_entered():
	description.bbcode_text = "[right] +1 Health [/right]"
	selectedItem.text = "Apple"
	focused()


func _on_Apple_pressed():
	if buttonsEnabled:
		if stats.apples >= 1 && stats.health < stats.max_health:
			stats.health += 1
			stats.apples -= 1
			selected()
