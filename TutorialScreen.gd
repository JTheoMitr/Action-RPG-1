extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var plasmaBlade = $VBoxContainer/Button
onready var deflection = $VBoxContainer/Button2
onready var laserEye = $VBoxContainer/Button3
onready var rollDodge = $VBoxContainer/Button4
onready var chargeStones = $VBoxContainer/Button5
onready var levelUp = $VBoxContainer/Button6
onready var description = $DescriptionText
onready var videoPlayer = $VideoPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	plasmaBlade.grab_focus()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plasmaBlade.has_focus():
		description.bbcode_text = "[center]A Powerful Melee weapon that can cut through the toughest of enemies ([img=c, 10]res://World/gdb-playstation-2 square pressed still.png[/img]). Damage increases when the player levels up.[/center] "

	if deflection.has_focus():
		description.bbcode_text = "[center]Use your plasma blade ([img=c,10]res://World/gdb-playstation-2 square pressed still.png[/img]) to deflect incoming projectiles. Hold any direction while attacking; player charge type must match projectile color."

	if laserEye.has_focus():
		description.bbcode_text = "[center]Use ([img=c,15]res://World/gdb-playstation-2 circle flat.png[/img]) to fire your laser eye; hold to bring up a crosshair and aim (can be performed while moving)."

	if rollDodge.has_focus():
		description.bbcode_text = "[center]Use ([img=c,15]res://World/gdb-playstation-2 cross flat.png[/img]) to perform a quick roll, granting the player a brief moment of invulnerability."

	if chargeStones.has_focus():
		description.bbcode_text = "[center]Charge stones give your blade the ability to deflect new projectile types. You can swap charge colors ( [img=c,15]res://UI/gdb-playstation-2 L1 pressed single.png[/img] or [img=c,15]res://UI/gdb-playstation-2 R1 pressed Single.png[/img] ) to adapt to your enemy while in combat."

	if levelUp.has_focus():
		description.bbcode_text = "[center]Collect XP orbs from defeated enemies to level up your character; increases DMG and other stats."



func _on_Button_pressed():
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_VideoPlayer_finished():
	$VideoPlayer.play()


func _on_Button2_focus_entered():
	videoPlayer.stream = load("res://UI/deflection.webm")
	videoPlayer.play()


func _on_Button4_focus_entered():
	videoPlayer.stream = load("res://UI/rollDodge.webm")
	videoPlayer.play()


func _on_Button3_focus_entered():
	videoPlayer.stream = load("res://UI/laserEye.webm")
	videoPlayer.play()


func _on_Button_focus_entered():
	videoPlayer.stream = load("res://UI/plasmaBlade.webm")
	videoPlayer.play()


func _on_Button5_focus_entered():
	videoPlayer.stream = load("res://UI/chargeSwap.webm")
	videoPlayer.play()
