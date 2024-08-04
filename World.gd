extends Node2D



onready var musicPlayer = $AudioStreamPlayer
onready var musicTimer = $MusicTimer
onready var tween_out = $Tween
onready var blastAnim = $CanvasLayer/AmmoUI/BlastAnim
onready var stealthUI = $CanvasLayer/StealthUI
onready var keyAlert = $AlertCanvas/KeyAlert

export var transition_duration = 3.00
export var transition_type = 1 # TRANS_SINE
export var laser_effect: PackedScene

var worldStats = WorldStats
var stats = PlayerStats

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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


func _on_Timer_timeout():
	pass


func _on_Timer2_timeout():
	pass
	#takePhoto()
