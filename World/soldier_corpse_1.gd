extends StaticBody2D

const PickUpSound = preload("res://Music and Sounds/PickUpSoundThree.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const NORMAL_SPEED = 0.06
const ELLIPSIS_SPEED = 0.5
onready var popup = $Popup
onready var popup2 = $Popup2
onready var timer = $Timer
onready var timer2 = $Timer2
onready var timer3 = $Timer3
onready var text_label = $Popup/RichTextLabel
onready var chatter = $Chatter
var letter_count
var full_text_one
#var full_text_two
#var full_text_three

var reading_one
#var reading_two
#var reading_three
# Called when the node enters the scene tree for the first time.
func _ready():
	reading_one = true
#	reading_two = false
#	reading_three = false
	letter_count = 0
	timer.wait_time = NORMAL_SPEED
	full_text_one = "Something ripped this \n soldier to pieces..."
	#add another pop-up *You found the flashlight/torch, this will automatically turn on in dark areas
	text_label.bbcode_text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Area2D_area_entered(area):
	chatter.play()
	popup.popup()
	popup.rect_global_position.x = self.global_position.x
	popup.rect_global_position.y = self.global_position.y
	timer.start()

func _on_Timer_timeout():
	if letter_count <= full_text_one.length() && reading_one:
		text_label.bbcode_text = "[center]" + full_text_one.substr(0, letter_count)
		letter_count += 1
		if letter_count < full_text_one.length() && full_text_one[letter_count] == ".":
			timer.wait_time = ELLIPSIS_SPEED
		else:
			timer.wait_time = NORMAL_SPEED
			
#	if letter_count <= full_text_two.length() && reading_two:
#		text_label.bbcode_text = "[center]" + full_text_two.substr(0, letter_count)
#		letter_count += 1
#		if letter_count < full_text_two.length() && full_text_two[letter_count] == ".":
#			timer.wait_time = ELLIPSIS_SPEED
#		else:
#			timer.wait_time = NORMAL_SPEED
#
#	if letter_count <= full_text_three.length() && reading_three:
#		if letter_count > 15:
#			timer2.start()
#		text_label.bbcode_text = "[center]" + full_text_three.substr(0, letter_count)
#		letter_count += 1
#		if letter_count < full_text_three.length() && full_text_three[letter_count] == ".":
#			timer.wait_time = ELLIPSIS_SPEED
#		else:
#			timer.wait_time = NORMAL_SPEED
			
	if letter_count > full_text_one.length() && reading_one:
		timer2.start()
		letter_count = 0
		timer.stop()
#
#	if letter_count > full_text_two.length() && reading_two:
#		reading_two = false
#		reading_three = true
#		letter_count = 0
		
		
	print_debug(letter_count)
	
	


func _on_Timer2_timeout():
	popup.hide()
	popup2.popup()
	popup2.rect_global_position.x = self.global_position.x
	popup2.rect_global_position.y = self.global_position.y
	timer3.start()
	var item_sound = PickUpSound.instance()
	add_child(item_sound)
	item_sound.play()


func _on_Timer3_timeout():
	popup.hide()
	popup2.hide()
