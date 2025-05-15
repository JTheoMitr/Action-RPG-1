extends Node2D

const NewSkill = preload("res://Music and Sounds/NewSkill.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup = $PopupDialog
onready var timer = $Timer
onready var walkie = $Sprite
onready var magic = $AnimatedSprite
onready var walkieScooped = $PopupDialog2
onready var timer2 = $Timer2
onready var timer3 = $Timer3
onready var walkieMSG = $PopupDialog/RichTextLabel
onready var chatter = $Chatter

onready var save_file = SaveFile.g_data
var playerStats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for you."
	yield(get_tree().create_timer(0.1), "timeout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position = self.global_position
	walkieScooped.rect_global_position = self.global_position


func _on_Area2D_area_entered(area):
	walkieScooped.popup()
	timer.start()
	magic.hide()
	walkie.hide()
	playerStats.walkieObtained = true
	save_file.walkie_obtained = true
	SaveFile.save_data()
	#add this stat to the save file as well
	var newSkill = NewSkill.instance()
	get_tree().current_scene.add_child(newSkill)
	playerStats.controlsOn = false
	
	
	


func _on_Timer_timeout():
	chatter.play(0.0)
	walkieScooped.hide()
	popup.popup()
	timer2.start()
	timer3.start()
	walkieMSG.text = " "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " E"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Ex"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Exc"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Exce"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excel"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excell"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excelle"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellen"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent,"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, y"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, yo"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you'"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you'v"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n f"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n fo"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n fou"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n foun"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found t"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found th"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-w"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-wa"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n r"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n ra"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n rad"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radi"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio T"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio Th"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio Tha"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I l"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I le"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I lef"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n f"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n fo"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for y"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for yo"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for you"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for you."
	yield(get_tree().create_timer(0.7), "timeout")


	
	
	
	


func _on_Timer2_timeout():
	playerStats.controlsOn = true #test this
	queue_free()



func _on_Timer3_timeout():
	chatter.play(0.0)
	walkieMSG.text = " "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " C"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Co"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Con"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Cont"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Conta"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contac"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact m"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n w"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n wh"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n whe"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when y"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when yo"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you a"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you ar"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arr"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arri"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arriv"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n i"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in."
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in ."
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in t"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in th"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the "
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the c"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the ca."
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the cav"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the cave"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the caver"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the cavern"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the caverns"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the caverns."
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the caverns.."
	yield(get_tree().create_timer(0.1), "timeout")
	walkieMSG.text = " Contact me \n when you arrive \n in the caverns..."
	yield(get_tree().create_timer(0.5), "timeout")

	
	
	
	
