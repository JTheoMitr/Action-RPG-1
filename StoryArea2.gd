extends Area2D

const ChatterSound = preload("res://Music and Sounds/GuideBotChatterSound.tscn")
const NewSkill = preload("res://Music and Sounds/NewSkill.tscn")

onready var popup = $CanvasLayer/StoryDialog2
onready var question = $CanvasLayer/QuestionPopUp
onready var dialog = $CanvasLayer/StoryDialog2/RichTextLabel
onready var stats = PlayerStats
onready var response = $CanvasLayer/Response
onready var yes = $CanvasLayer/QuestionPopUp/HBoxContainer/Yes
onready var responseText = $CanvasLayer/Response/RichTextLabel
onready var timer = $Timer
onready var skillTimer = $SkillDescTimer
onready var skillPop = $CanvasLayer/SkillPopUp
onready var save_file = SaveFile.g_data
onready var panel = $CanvasLayer/Panel
onready var finaleTimer = $Timer2
# onready var chatterSound = ChatterSound.instance()

var inArea = false
var yesPress = false
var noPress = false
var finalDialogue = false
var soundCatch = false
var skillPopShow = false

var textNumber = 0
var textNumberTwo = 0
var textNumberThree = 0

var textOptions = ["[center]\nWAIT![center]", "[center] \n I'm no enemy... \n I've come to help \nsave your friends.[/center]", "[center] \nThe robots are \n drilling for the evil \n oil company...OILCO![/center]", "[center] \n I can stop them, \n but I need access to \n the OILCO mainframe...[/center]", "[center] \n Will you help me? \n Together we can \n save this forest![/center]"]
var textOptionsTwo = ["[center] \n \nSplendiferous! [/center]", "[center]\n You will need to head \n to Wylde Caverns.[/center]", "[center] \n They lead to the \n city outskirts.[/center]", "[center] \n The entrance lies in \n the Northeast corner \n of the forest[/center]", "[center] \n Once in the city, we \n can make our way to \n the Resistance HQ[/center]", "[center] \n There are many that \n want to stop OILCO, \n just like us...[/center]","[center] \n \n One more thing![/center]", "[center] \n Please allow me to \n teach you a new skill:[/center]", "[center][shake] OVERCHARGE [/shake][/center]", "[center] \n This ThermoCharge will \n overheat any floppy \n disk it touches[/center]", "[center] \n Use it to emit a \n damaging energy blast.[/center]", "[center] \n I have a couple \n floppies to get \n you started [/center]", "[center]\n The OILCO tools and \n weapons are powered by \n disks. Easy to find.[/center]",  "[center] \n I shall see you again \n in the depths of \n Wylde Caverns[/center]", ""]
var textOptionsThree = ["[center] \n Oh, my mistake.  \n You're giving off \n serious hero vibes...[/center]", "[center] \n I assumed you \n wanted to save \n the entire forest...[/center]", "[center] \n All good though, \n I'll look for someone a \n bit more up to it.[/center]", "[center] \n Come on back if you \n change your mind...[/center]", ""]



func _ready():
	panel.hide()
	if save_file.overcharge_status == true:
		queue_free()
	else:
		dialog.bbcode_enabled = true
	
func _process(delta):
	
	if skillPopShow == true:
		if Input.is_action_just_pressed("interact"):
			finaleTimer.start()
			
	if textNumber == 0:
		dialog.get_font("normal_font").size = 18
	if textNumber >= 1 && textNumber < 5:
		popup.show()
		dialog.bbcode_text = textOptions[textNumber]
		dialog.get_font("normal_font").size = 10
	
	if (inArea == true) && Input.is_action_just_pressed("interact"):
		print(textNumber)
		
		if textNumber < 4:
			textNumber +=1
		elif textNumber == 4:
			textNumber += 1
			popup.hide()
			question.show()
			yes.grab_focus()
		else:
			textNumber = 5

	if yesPress == true:
		if Input.is_action_just_pressed("interact"):
			if textNumberTwo >= 0 && textNumberTwo <= 7:
				textNumberTwo += 1
				dialog.bbcode_text = textOptionsTwo[textNumberTwo]
			if textNumberTwo == 8:
				if soundCatch == false:
					var chatterSound = ChatterSound.instance()
					get_tree().current_scene.add_child(chatterSound)
					timer.start()
				soundCatch = true
				response.show()
				popup.hide()
				responseText.bbcode_text = textOptionsTwo[textNumberTwo]
				
	
	if noPress == true:
		if Input.is_action_just_pressed("interact"):
			print(textNumberThree)
			if textNumberThree >= 0 && textNumberThree <= 3:
				textNumberThree += 1
				dialog.bbcode_text = textOptionsThree[textNumberThree]
			if textNumberThree == 4:
				_reset()
				
	if finalDialogue == true:
		if Input.is_action_just_pressed("interact"):
			textNumberTwo += 1
			if textNumberTwo < 14:
				dialog.bbcode_text = textOptionsTwo[textNumberTwo]
			if textNumberTwo == 14:
				stats.emit_signal("player_resumed")
				response.hide()
				popup.hide()
				
				skillTimer.start()
			if textNumberTwo >= 15:
				print("we past it all")
				

func _reset():
	
	popup.hide()
	inArea = false
	stats.emit_signal("player_resumed")
	textNumber = 0
	textNumberTwo = 0
	textNumberThree = 0
	noPress = false
	dialog.bbcode_text = textOptions[textNumber]

func _on_StoryArea2_area_entered(area):
	popup.popup()
	panel.show()
	var chatterSound = ChatterSound.instance()
	get_tree().current_scene.add_child(chatterSound)
	inArea = true
	stats.emit_signal("player_paused")


func _on_Yes_pressed():
	question.hide()
	popup.show()
	yesPress = true
	dialog.bbcode_text = textOptionsTwo[textNumberTwo]
	

func _on_No_pressed():
	question.hide()
	popup.show()
	noPress = true
	dialog.bbcode_text = textOptionsThree[textNumberThree]


func _on_Timer_timeout():
	textNumberTwo = 9
	response.hide()
	popup.show()
	dialog.bbcode_text = textOptionsTwo[textNumberTwo]
	finalDialogue = true
	timer.queue_free()


func _on_SkillDescTimer_timeout():
	var newSkill = NewSkill.instance()
	get_tree().current_scene.add_child(newSkill)
	skillPop.show()
	stats.overcharge = true
	save_file.overcharge_status = true
	stats.emit_signal("player_paused")
	skillPopShow = true
	skillTimer.queue_free()



func _on_Timer2_timeout():
	queue_free()
	stats.emit_signal("player_resumed")
