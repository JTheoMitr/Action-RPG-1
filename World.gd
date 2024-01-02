extends Node2D



onready var musicPlayer = $AudioStreamPlayer
onready var musicTimer = $MusicTimer
onready var tween_out = $Tween
onready var blastAnim = $CanvasLayer/AmmoUI/BlastAnim

export var transition_duration = 3.00
export var transition_type = 1 # TRANS_SINE
export var laser_effect: PackedScene

var worldStats = WorldStats

# Called when the node enters the scene tree for the first time.
func _ready():
	musicPlayer.play()
	worldStats.connect("fade_music_in", self, "raise_music_volume")
	worldStats.connect("fade_music_out", self, "lower_music_volume")
	worldStats.connect("lowest_volume", self, "lower_music_volume")
	generate_laser_effect(Vector2(-1248, 459.451538))
	#$CanvasLayer/BatteryUI.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func raise_music_volume():
	print("fading_in")
	tween_out.interpolate_property(musicPlayer, "volume_db", -45, -20, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	
func lower_music_volume():
	print("fading_out")
	tween_out.interpolate_property(musicPlayer, "volume_db", -20, -45, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	
func lowest_music_volume():
	print("lowest")
	
func generate_laser_effect(laser_position: Vector2)->void:
	var temp = laser_effect.instance()
	add_child(temp)
	temp.position = laser_position


func _on_MusicTimer_timeout():
	musicPlayer.volume_db = -20


func _on_Player_fired_shot(hit_position: Vector2):
	generate_laser_effect(hit_position)
	blastAnim.frame = 0
	blastAnim.play("fire")
	print(hit_position)
