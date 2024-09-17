extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var plasmaBlade = $VBoxContainer/Button
onready var deflection = $VBoxContainer/Button2
onready var laserEye = $VBoxContainer/Button3
onready var rollDodge = $VBoxContainer/Button4
onready var chargeStones = $VBoxContainer/Button5
onready var tvFuzz = $TVFuzz
onready var phaseAtk = $VBoxContainer/Button7
onready var description = $DescriptionText
onready var videoPlayer = $VideoPlayer
onready var timer = $Timer
onready var staticSound = $AudioStreamPlayer

var mute
# Called when the node enters the scene tree for the first time.
func _ready():
	plasmaBlade.grab_focus()
	tvFuzz.hide()
	mute = true





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plasmaBlade.has_focus():
		description.bbcode_text = "[center]A Powerful Melee weapon that can cut through the toughest of enemies. Attack with ([img=c, 10]res://World/gdb-playstation-2 square pressed still.png[/img]); Damage increases when the player levels up.[/center] "

	if deflection.has_focus():
		description.bbcode_text = "[center]Hold any direction while attacking with your plasma blade ([img=c,10]res://World/gdb-playstation-2 square pressed still.png[/img]) to deflect incoming projectiles. Blade Color must match projectile color (see: energy types)."

	if laserEye.has_focus():
		description.bbcode_text = "[center]Use ([img=c,15]res://World/gdb-playstation-2 circle flat.png[/img]) to fire your laser eye; holding will bring up a crosshair for precision aiming (can be performed while moving)."

	if rollDodge.has_focus():
		description.bbcode_text = "[center]Use ([img=c,15]res://World/gdb-playstation-2 cross flat.png[/img]) to perform a quick roll, granting the player a brief moment of invulnerability."

	if chargeStones.has_focus():
		description.bbcode_text = "[center]Match your blade's energy type (noted by color) with enemy projectiles to deflect or destroy them. You can swap energies while in combat with ( [img=c,15]res://UI/gdb-playstation-2 L1 pressed single.png[/img] or [img=c,15]res://UI/gdb-playstation-2 R1 pressed Single.png[/img] ). Find energy stones to acquire new colors for your blade."

	if phaseAtk.has_focus():
		description.bbcode_text = "[center]Hold ([img=c, 10]res://World/gdb-playstation-2 square pressed still.png[/img]) until your charge meter is full to perform your phase attack: A quick slash in 4 directions, the player is also granted a brief moment of invulnerability.[/center]"
	

		
	



func _on_Button_pressed():
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_VideoPlayer_finished():
	$VideoPlayer.play()


func _on_Button2_focus_entered():
	videoPlayer.stream = load("res://UI/deflection.webm")
	videoPlayer.play()
	tvFuzz.show()
	timer.start()
	staticSound.play()
	mute = false
	


func _on_Button4_focus_entered():
	videoPlayer.stream = load("res://UI/rollDodge.webm")
	videoPlayer.play()
	tvFuzz.show()
	timer.start()
	staticSound.play()


func _on_Button3_focus_entered():
	videoPlayer.stream = load("res://UI/laserEye.webm")
	videoPlayer.play()
	tvFuzz.show()
	timer.start()
	staticSound.play()


func _on_Button_focus_entered():
	videoPlayer.stream = load("res://UI/plasmaBlade.webm")
	videoPlayer.play()
	tvFuzz.show()
	timer.start()
	if mute == false:
		staticSound.play()


func _on_Button5_focus_entered():
	videoPlayer.stream = load("res://UI/chargeSwap.webm")
	videoPlayer.play()
	tvFuzz.show()
	timer.start()
	staticSound.play()


func _on_Button7_focus_entered():
	videoPlayer.stream = load("res://UI/phaseAtk.webm")
	videoPlayer.play()
	tvFuzz.show()
	timer.start()
	staticSound.play()


func _on_Timer_timeout():
	tvFuzz.hide()

