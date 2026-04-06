extends Node2D



onready var musicPlayer = $AudioStreamPlayer
onready var musicTimer = $MusicTimer
onready var tween_out = $Tween
onready var blastAnim = $CanvasLayer/AmmoUI/BlastAnim
onready var stealthUI = $CanvasLayer/StealthUI
onready var keyAlert = $AlertCanvas/KeyAlert
onready var camera = $Camera2D
onready var tween = $Camera2D/Tween
onready var portal_1 = $YSort/Doors/PortalDoor

export var transition_duration = 3.00
export var transition_type = 1 # TRANS_SINE
export var laser_effect: PackedScene

var worldStats = WorldStats
var stats = PlayerStats

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
	worldStats.connect("pylon_activated", self, "pylon_1_popped")
	stats.connect("level_changed", self, "leveled")
	#$Timer2.start() // camera timer
	generate_laser_effect(Vector2(-1248, 459.451538))
	#stats.set_max_health(5)
	#stats.set_health(5)
	#$CanvasLayer/BatteryUI.hide()
#	canvasModulate.visible = false
#	darkPanel.visible = false
#	darkPanel.self_modulate.a = 0.0
#	going_dark = false
#	into_the_light = false
#	lightness = true
#	darkness = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if going_dark && darkPanel.self_modulate.a < 1.0:
#		darkPanel.visible = true
#		darkPanel.self_modulate.a += .005
#	if into_the_light && darkPanel.self_modulate.a > 0.0:
#		darkPanel.visible = true
#		darkPanel.self_modulate.a -= .005
#
#	if darkPanel.self_modulate.a == 0.0 && darkness:
#		lightness = true
#		darkness = false
#		print_debug("lightness")
#		darkPanel.visible = false
#		canvasModulate.visible = false
#
#	if darkPanel.self_modulate.a == 1.0 && lightness:
#		lightness = false
#		darkness = true
#		print_debug("darkness")
#		darkPanel.visible = false
#		canvasModulate.visible = true
	
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

func trigger_zoom_and_slow(target_global_pos: Vector2) -> void:
	var original_zoom = camera.zoom
	var original_offset = camera.offset
	var original_time_scale = Engine.time_scale

	# Tune these
	var slow_scale = 0.65 #was 0.35
	var zoomed_in = Vector2(0.75, 0.75) #was 1.8, 1.8
	var pan_strength = 0.75   # 0.0 = no focus shift, 1.0 = full shift toward target

	Engine.time_scale = slow_scale

	# Vector from current camera center to soldier
	var to_target = target_global_pos - camera.global_position
	var target_offset = to_target * pan_strength

	tween.stop_all()

	# First: push in and focus the soldier more aggressively
	tween.interpolate_property(
		camera, "zoom",
		original_zoom, zoomed_in, 1.0,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		camera, "offset",
		original_offset, target_offset, 1.0,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)

	tween.start()
	yield(tween, "tween_all_completed")

	# Tiny hold so the player registers what they're seeing
	yield(get_tree().create_timer(0.08), "timeout")

	# Explosion happens HERE
	# Example:
	# soldier.explode()
	worldStats.emit_signal("portal_opened")
	# Let the explosion breathe in slow-mo
	yield(get_tree().create_timer(0.22), "timeout")

	# Restore time first or after, depending on feel
	Engine.time_scale = original_time_scale

	tween.stop_all()

	tween.interpolate_property(
		camera, "zoom",
		camera.zoom, original_zoom, 1.0,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		camera, "offset",
		camera.offset, original_offset, 1.0,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)

	tween.start()


func pylon_1_popped() -> void:
	trigger_zoom_and_slow(portal_1.global_position)
