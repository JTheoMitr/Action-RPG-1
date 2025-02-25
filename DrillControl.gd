extends Node2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
const Explode = preload("res://Effects/ExplosionEffect.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var destroyedJam = $Destroyed
onready var canvasLayer = $CanvasLayer
onready var canvasSprite = $CanvasLayer/Sprite
onready var redLight = $RedLight
onready var blinkTimer = $BlinkTimer
onready var light = $Light
onready var furnace = $Furnace
onready var drillDisplay = $CanvasLayer/Sprite/OilDrill1
onready var shakeTimer = $ShakeTimer
onready var clouds1 = $Clouds1
onready var clouds2 = $Clouds2
onready var clouds3 = $Clouds3
onready var clouds4 = $Clouds4
onready var clouds5 = $Clouds5
onready var clouds6 = $Clouds6
onready var clouds7 = $Clouds7
onready var clouds8 = $Clouds8
onready var clouds9 = $Clouds9
onready var clouds10 = $Clouds10
onready var clouds11 = $Clouds11
onready var clouds12 = $Clouds12
onready var clouds13 = $Clouds13
onready var panel = $Sprite7/Panel
onready var fadeTimer = $FadeTimer
onready var fadeFinishTimer = $FadeFinishTimer
onready var fadeSwitchTimer = $FadeSwitchTimer
onready var rattle = $Rattle
onready var tank1 = $Sprite
onready var tankdmg = $Sprite8
onready var furnaceDMG = $FurnaceDMG
onready var explodeTimer = $ExplodeTimer
onready var bigExplodeAnim = $CanvasLayer/Sprite/Drillsplosion
onready var bigExplodeAudio = $CanvasLayer/Sprite/Boom
onready var destroyedPanel = $CanvasLayer/Sprite/DestroyedPanel
onready var drillCtrlText = $Sprite4
onready var drillscrn1 = $Sprite2
onready var drillscrn2 = $Sprite5
onready var chatter  = $Chatter
onready var uiSprite = $CanvasLayer/UISprite
onready var uiPanel = $CanvasLayer/Panel
onready var walkieText = $CanvasLayer/UISprite/RichTextLabel
var exploding
var shakeLeft
var shakeRight
var hits
var playerStats = PlayerStats
var worldStats = WorldStats
var hiding
var rattlin

var fadeToWhite
var fadeToBlack
var fadeCanvas

# Called when the node enters the scene tree for the first time.
func _ready():
	blinkTimer.start()
	bigExplodeAnim.frame = 79
	shakeLeft = false
	shakeRight = false
	hits = 0
	exploding = false
	hiding = false
	rattlin = false
	uiSprite.hide()
	furnaceDMG.frame = 0
	furnaceDMG.hide()
	canvasLayer.hide()
	fadeToWhite = true
	fadeToBlack = false
	fadeCanvas = false
	destroyedPanel.hide()
	uiPanel.hide()
	
	clouds6.hide()
	clouds7.hide()
	clouds8.hide()
	clouds9.hide()
	clouds10.hide()
	clouds11.hide()
	clouds12.hide()
	clouds13.hide()
	
	panel.modulate.a = 0.0
	
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakeLeft:
		furnace.global_position.x -= 0.1
	if shakeRight:
		furnace.global_position.x += 0.1
		
	if hiding:
		redLight.hide()
	if !hiding:
		redLight.show()
	#control coloring and shakeTimer based on hits:
	
	if hits >= 2 && hits < 3:
		self.modulate.g = 0.7
		self.modulate.b = 0.7
		shakeTimer.start()
	if hits >= 3 && hits < 4:
		if rattlin == false:
			rattle.play(0.0)
			rattlin = true
	if hits >= 5 && hits < 6:
		
		self.modulate.g = 0.5
		self.modulate.b = 0.5
	
	if hits >= 7 && hits < 8:
		self.modulate.g = 0.3
		self.modulate.b = 0.3
		
		clouds6.show()
		clouds7.show()
		clouds8.show()
		clouds9.show()
		clouds10.show()
		clouds11.show()
		clouds12.show()
		clouds13.show()
	if hits >= 9:
		if exploding == false:
			_exploding()
			rattle.stop()
			exploding = true
	


func _on_BlinkTimer_timeout():
	if hiding == false:
		hiding = true
	else:
		hiding = false

func _exploding():
		playerStats.controlsOn = false
		var explode = Explode.instance()
		get_parent().add_child(explode)
		explode.global_position.x = global_position.x
		explode.global_position.y = global_position.y
		fadeTimer.start(0.0)
		fadeSwitchTimer.start(0.0)
		fadeFinishTimer.start(0.0)
		yield(get_tree().create_timer(0.3), "timeout")
		var explode2 = Explode.instance()
		get_parent().add_child(explode2)
		explode2.global_position.x = global_position.x + 43
		explode2.global_position.y = global_position.y + 16
		yield(get_tree().create_timer(0.3), "timeout")
		var explode3 = Explode.instance()
		get_parent().add_child(explode3)
		explode3.global_position.x = global_position.x - 21
		explode3.global_position.y = global_position.y + 40
		furnace.hide()
		furnaceDMG.show()
		tank1.hide()
		
		blinkTimer.stop()
		
		furnaceDMG.play("default")
		yield(get_tree().create_timer(0.3), "timeout")
		
		var explode4 = Explode.instance()
		get_parent().add_child(explode4)
		explode4.global_position.x = global_position.x + 51
		explode4.global_position.y = global_position.y + 36
		yield(get_tree().create_timer(0.3), "timeout")
		
		var explode5 = Explode.instance()
		get_parent().add_child(explode5)
		explode5.global_position.x = global_position.x - 12
		explode5.global_position.y = global_position.y - 6
		yield(get_tree().create_timer(0.3), "timeout")
		var explode6 = Explode.instance()
		get_parent().add_child(explode6)
		explode6.global_position.x = global_position.x + 90
		explode6.global_position.y = global_position.y + 31
		tankdmg.hide()
		yield(get_tree().create_timer(0.3), "timeout")
		var explode7 = Explode.instance()
		get_parent().add_child(explode7)
		explode7.global_position.x = global_position.x - 25
		explode7.global_position.y = global_position.y - 32
		worldStats.emit_signal("fade_music_out")
		yield(get_tree().create_timer(0.3), "timeout")
		var explode8 = Explode.instance()
		get_parent().add_child(explode8)
		explode8.global_position.x = global_position.x + 13
		explode8.global_position.y = global_position.y + 32
		yield(get_tree().create_timer(0.3), "timeout")
		var explode9 = Explode.instance()
		get_parent().add_child(explode9)
		explode9.global_position.x = global_position.x - 37
		explode9.global_position.y = global_position.y + 1
		yield(get_tree().create_timer(0.3), "timeout")
		var explode10 = Explode.instance()
		get_parent().add_child(explode10)
		explode10.global_position.x = global_position.x + 58
		explode10.global_position.y = global_position.y + 1
		yield(get_tree().create_timer(0.3), "timeout")
		hiding = true
		
		pass #explode, then fade to white during, then popup plays showing drill explosion , banner for drill destroyed, plus 500 xp (final number of xp TBD)
		
	

func _on_Light_area_entered(area):
	var hitEff = HitEffect.instance()
	get_parent().add_child(hitEff)
	hitEff.global_position.x = redLight.global_position.x
	hitEff.global_position.y = redLight.global_position.y + 12
	hits += 1


func _on_ShakeTimer_timeout():
	if shakeLeft:
		shakeLeft = false
		shakeRight = true
	else:
		shakeLeft = true
		shakeRight = false


func _on_FadeTimer_timeout():
	if fadeToWhite:
		panel.modulate.a += 0.1
	if fadeToBlack:
		panel.modulate.r -= 0.1
		panel.modulate.g -= 0.1
		panel.modulate.b -= 0.1
	if fadeCanvas:
		canvasSprite.modulate.a -= 0.1
		panel.modulate.a -= 0.1


func _on_FadeFinishTimer_timeout():
	fadeTimer.stop()
	panel.modulate.a = 1.0
	panel.modulate.r = 0.0
	panel.modulate.g = 0.0
	panel.modulate.b = 0.0
	#redLight.hide()
	canvasLayer.show()
	explodeTimer.start()
	


func _on_FurnaceDMG_animation_finished():
	furnaceDMG.stop()
	furnaceDMG.frame = 3
	clouds1.queue_free()
	clouds2.queue_free()
	clouds3.queue_free()
	clouds4.queue_free()
	clouds5.queue_free()
	clouds6.queue_free()
	clouds7.queue_free()
	clouds8.queue_free()
	clouds9.queue_free()
	clouds10.queue_free()
	clouds11.queue_free()
	clouds12.queue_free()
	clouds13.queue_free()



func _on_FadeSwitchTimer_timeout():
	fadeToBlack = true
	fadeToWhite = false


func _on_ExplodeTimer_timeout():
	bigExplodeAnim.frame = 0
	bigExplodeAnim.play("default")
	bigExplodeAudio.play(0.0)
	destroyedJam.play()
	drillCtrlText.hide()
	drillscrn1.hide()
	drillscrn2.hide()
	redLight.hide()
	
	yield(get_tree().create_timer(0.3), "timeout")
	drillDisplay.hide()
	yield(get_tree().create_timer(2.0), "timeout")
	destroyedPanel.show()
	#play sound here
	yield(get_tree().create_timer(2.5), "timeout")
	fadeTimer.start()
	fadeCanvas = true
	yield(get_tree().create_timer(3.0), "timeout")
	fadeTimer.stop()
	panel.queue_free()
	canvasSprite.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	uiSprite.show()
	uiPanel.show()
	chatter.play()
	walkieText.bbcode_text = "Y"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YO"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU D"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU DI"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU DID"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU DID \nI"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU DID \nIT"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "YOU DID \nIT!"
	yield(get_tree().create_timer(2.5), "timeout")
	chatter.play()
	walkieText.bbcode_text = "O"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OI"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OIL"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILC"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO W"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WI"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WIL"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nB"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE F"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FO"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FOR"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FORC"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FORCE"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FORCED"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FORCED"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "OILCO WILL \nBE FORCED"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "T"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO L"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO LE"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO LEA"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO LEAV"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO LEAVE \n"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nT"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTH"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHI"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHIS"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHIS A"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHIS AR"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHIS ARE"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHIS AREA"
	yield(get_tree().create_timer(0.1), "timeout")
	walkieText.bbcode_text = "TO lEAVE \nTHIS AREA"
	yield(get_tree().create_timer(2.5), "timeout")

	uiSprite.hide()
	uiPanel.hide()
	
	playerStats.controlsOn = true



func _on_Drillsplosion_animation_finished():
	bigExplodeAnim.queue_free()
	
	


func _on_Destroyed_finished():
	destroyedJam.play()
