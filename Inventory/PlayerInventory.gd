extends Node2D

onready var redPop = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button/RPOPQ
onready var bluePop = $Control/CenterContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button2/BPOPQ
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
onready var timer = $Timer
onready var levelText = $Control/CenterContainer/HBoxContainer/Panel/LevelText
onready var displayMap = $ForestWorldMap
onready var map = $Map
onready var mapButton = $MapButton
onready var mapShadow = $MapShadow
onready var popup = $PopupDialog
onready var selectedItem = $Control/CenterContainer/HBoxContainer/VBoxContainer/Panel/PSPI


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




func _ready():
	stats.connect("map_pickup", self, "swap_map")
	stats.connect("enable_pause", self, "free_pause")
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
	
func _process(_delta):
	
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
		
	redPop.text = str(stats.redpops)
	bluePop.text = str(stats.bluepops)
	levelText.text = "Level " + str(stats.level)
	
	
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

func _on_Button_pressed(): #redpop
	if buttonsEnabled:
		if stats.redpops >= 1 && stats.health < stats.max_health:
			stats.health += 2
			stats.redpops -= 1
			selected()


func _on_Button_focus_entered():
	description.bbcode_text = "[right] +2 Health [/right]"
	selectedItem.text = "Red Pop"
	if menuOn == true:
		focused()


func _on_Button2_focus_entered():
	description.bbcode_text = "[right] +1 Energy [/right]"
	selectedItem.text = "Floppy Disk"
	focused()
	menuOn = true


func _on_Button3_focus_entered():
	description.bbcode_text = "[right] Quit Demo [/right]"
	focused()




func _on_Button2_pressed(): #bluepop
	if buttonsEnabled:
		if stats.bluepops >= 1 && stats.batteries < stats.max_batteries:
			stats.batteries += 1
			stats.bluepops -= 1
			selected()


func _on_Button3_pressed():
	popup.popup()
	popup.rect_global_position.y = self.global_position.y - 10
	popup.rect_global_position.x = self.global_position.x - 50
	$PopupDialog/Sprite/HBoxContainer/PopUpButton.grab_focus()


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
