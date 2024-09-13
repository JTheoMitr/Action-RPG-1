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
onready var plasmaBladeImg = $PlasmaBladeImg
onready var deflectImg = $DeflectImg
onready var laserEyeImg = $LaserEyeImg
onready var rollDodgeImg = $RollDodgeImg

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.grab_focus()
	deflectImg.hide()
	plasmaBladeImg.show()
	plasmaBlade.grab_focus()
	laserEyeImg.hide()
	rollDodgeImg.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plasmaBlade.has_focus():
		description.bbcode_text = "[center]A Powerful Melee weapon that can cut through the toughest of enemies (    ). Damage increased when the player levels up. "
		plasmaBladeImg.show()
		deflectImg.hide()
	if deflection.has_focus():
		description.bbcode_text = "[center]Use your plasma blade (    ) to deflect incoming projectiles. Hold any direction while attacking to send the projectile back at your enemy."
		plasmaBladeImg.hide()
		laserEyeImg.hide()
		deflectImg.show()
	if laserEye.has_focus():
		description.bbcode_text = "[center]Use (    ) to fire your laser eye; hold to bring up a crosshair and aim (can be performed while moving)."
		deflectImg.hide()
		laserEyeImg.show()
		rollDodgeImg.hide()
	if rollDodge.has_focus():
		description.bbcode_text = "[center]Use (    ) to perform a quick roll, granting the player a brief moment of invulnerability."
		laserEyeImg.hide()
		rollDodgeImg.show()
	if chargeStones.has_focus():
		description.bbcode_text = "[center]Charge stones give your blade the ability to deflect new projectile types. You can swap charge types (      or      ) to adapt to your enemy while in combat."
		rollDodgeImg.hide()
	if levelUp.has_focus():
		description.bbcode_text = "[center]Collect XP orbs from defeated enemies to level up your character; increases DMG and other stats."


func _on_Button_pressed():
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_VideoPlayer_finished():
	$VideoPlayer.play()


func _on_Button2_focus_entered():
	videoPlayer.stream = load("res://UI/deflectnosoundtrimmed.webm")
	videoPlayer.play()
