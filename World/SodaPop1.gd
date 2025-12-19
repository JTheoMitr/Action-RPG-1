extends Area2D

const SodaSound = preload("res://Music and Sounds/SodaGulpSound.tscn")

var stats = PlayerStats

onready var popup = $PopupDialog
onready var popupText = $PopupDialog/RichTextLabel
onready var timer = $Timer
onready var sprite = $Sprite
onready var coll = $CollisionShape2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position.y = self.global_position.y + 10
	popup.rect_global_position.x = self.global_position.x - 5


func _on_Apple_area_entered(area):
	if stats.health < stats.max_health:
		stats.health += 1
		var pickUpSound = SodaSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		popupText.bbcode_text = "[center]+1 Health"
		sprite.hide()
		coll.call_deferred("queue_free")
		timer.start()
		popup.popup()
	elif stats.health == stats.max_health:
		timer.start()
		stats.apples += 1
		popupText.bbcode_text = "[center]+1 Soda"
		sprite.hide()
		coll.call_deferred("queue_free")
		popup.popup()


func _on_Timer_timeout():
	queue_free()
