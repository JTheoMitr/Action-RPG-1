extends Node2D



onready var musicPlayer = $AudioStreamPlayer
onready var musicTimer = $MusicTimer
onready var tween_out = $Tween
onready var blastAnim = $CanvasLayer/AmmoUI/BlastAnim
onready var stealthUI = $CanvasLayer/StealthUI
onready var keyAlert = $AlertCanvas/KeyAlert
onready var camera = $Camera2D
onready var canvasModulate = $CanvasModulate
onready var darkPanel = $CanvasLayer/DarknessPanel
onready var lightTimer = $LightTimer

export var transition_duration = 3.00
export var transition_type = 1 # TRANS_SINE
export var laser_effect: PackedScene

var worldStats = WorldStats
var stats = PlayerStats

const clickSound = preload("res://Effects/FlashlightClick.tscn")

var going_dark
var into_the_light

var darkness
var lightness

# Called when the node enters the scene tree for the first time.
func _ready():
	musicPlayer.play()
	worldStats.connect("fade_music_in", self, "raise_music_volume")
	worldStats.connect("fade_music_out", self, "lower_music_volume")
	worldStats.connect("lowest_volume", self, "lower_music_volume")
	worldStats.connect("in_the_tall_grass", self, "stealth_ui_on")
	worldStats.connect("out_of_the_tall_grass", self, "stealth_ui_off")
	worldStats.connect("play_blast_anim", self, "blast_animation")
	stats.connect("level_changed", self, "leveled")
	#$Timer2.start() // camera timer
	generate_laser_effect(Vector2(-1248, 459.451538))
	#stats.set_max_health(5)
	#stats.set_health(5)
	#$CanvasLayer/BatteryUI.hide()
	canvasModulate.visible = false
	darkPanel.visible = false
	darkPanel.self_modulate.a = 0.0
	going_dark = false
	into_the_light = false
	lightness = true
	darkness = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if going_dark && darkPanel.self_modulate.a < 1.0:
		darkPanel.visible = true
		darkPanel.self_modulate.a += .005
	if into_the_light && darkPanel.self_modulate.a > 0.0:
		darkPanel.visible = true
		canvasModulate.visible = false
	
	
func leveled():
	if stats.level >= 2:
		$Timer.start()
		


func raise_music_volume():
	print("fading_in")
	tween_out.interpolate_property(musicPlayer, "volume_db", -35, -3, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	
func lower_music_volume():
	print("fading_out")
	tween_out.interpolate_property(musicPlayer, "volume_db", -3, -35, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	
func lowest_music_volume():
	print("lowest")
	
func generate_laser_effect(laser_position: Vector2)->void:
	var temp = laser_effect.instance()
	add_child(temp)
	temp.position = laser_position


func _on_MusicTimer_timeout():
	musicPlayer.volume_db = -3
	


func _on_Player_fired_shot(hit_position: Vector2):
	generate_laser_effect(hit_position)
	print(hit_position)
	
func blast_animation():
	blastAnim.frame = 0
	blastAnim.play("fire")

func stealth_ui_on():
	stealthUI.show()
	
func stealth_ui_off():
	stealthUI.hide()

func takePhoto():
	var vpt = get_viewport()
	var txt = vpt.get_texture()
	var image = txt.get_data()
	image.flip_y()
	image.save_png("break.png")

func _on_AudioStreamPlayer_finished():
	musicPlayer.play(0.0)



func _on_DarkZone_area_entered(area):
	if lightness:
		lightTimer.start()
		going_dark = true
		into_the_light = false
		print_debug("going dark")


func _on_DarkZone_area_exited(area):
	if darkness:
		lightTimer.start()
		going_dark = false
		into_the_light = true
		print_debug("into the light")


func _on_LightTimer_timeout():
	if lightness:
		lightness = false
		darkness = true
		going_dark = false
		print_debug("darkness")
		darkPanel.visible = false
		var click = clickSound.instance()
		add_child(click)
		#play a flashlight click sound, do we change the panel white here for the 'entering light flash before the fade', or do we have two panels?
		canvasModulate.visible = true
	else:
		lightness = true
		darkness = false
		print_debug("lightness")
		into_the_light = false
		darkPanel.visible = false
		canvasModulate.visible = false
		
		
