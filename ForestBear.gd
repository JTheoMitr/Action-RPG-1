extends KinematicBody2D

const BearVaporEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var worldStats = WorldStats
var bearVapor = BearVaporEffect.instance()

onready var save_data = SaveFile.g_data
onready var stats = PlayerStats

func _ready():
	if save_data.forest_bear_saved == true:
		queue_free()
	

onready var popup = $RescuePopUp
onready var freedUp = $FreedPopup
onready var bear = $AnimatedSprite
onready var shadow = $ShadowSprite

func _process(delta):
	popup.rect_global_position = self.position
	freedUp.rect_global_position = self.position


func _on_Area2D_area_entered(area):
	popup.popup()
	$Timer.start()
	


func _on_Timer_timeout():
	var world = get_tree().current_scene
	get_parent().add_child(bearVapor)
	bearVapor.global_position = global_position
	freedUp.popup()
	popup.hide()
	bear.hide()
	shadow.hide()
	save_data.forest_bear_saved = true
	stats.forest_freed += 1
	PlayerStats.xp += 15
	SaveFile.save_data()
	$Timer2.start()


func _on_Timer2_timeout():
	queue_free()
