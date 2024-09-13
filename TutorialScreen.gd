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

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if plasmaBlade.has_focus():
		description.bbcode_text = "[center]A Powerful Melee weapon that can cut through the toughest of enemies (    ). Damage increased when the player levels up. "
	if deflection.has_focus():
		description.bbcode_text = "[center]Use your plasma blade (    ) to deflect incoming projectiles. Hold any direction while attacking to send the projectile back at your enemy. If no direction is held, the projectile is simply destroyed."
	if laserEye.has_focus():
		description.bbcode_text = "[center]Use (    ) to fire your laser eye; hold to bring up a crosshair and aim (can be performed while moving)."
	if rollDodge.has_focus():
		description.bbcode_text = "[center]Use (    ) to perform a quick roll, granting the player a brief moment of invulnerability."
	if chargeStones.has_focus():
		description.bbcode_text = "[center]Different charge stones give your blade the ability to deflect new projectile types. You can swap charge types (      or      ) to adapt to your enemy while in combat."
	if levelUp.has_focus():
		description.bbcode_text = "[center]Collect XP orbs from defeated enemies to level up your character; increases DMG and other stats."


func _on_Button_pressed():
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_VideoPlayer_finished():
	$VideoPlayer.play()
