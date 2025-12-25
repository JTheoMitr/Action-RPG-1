extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spinning_album = $AlbumSpin1
onready var popup = $Popup
onready var pop_timer = $PopTimer1
onready var music_bars = $Popup/AnimatedSprite
onready var music_found = $Popup/Sprite/RichTextLabel
onready var text_2 = $Popup/RichTextLabel
onready var spinning_album_2 = $Popup/Sprite/AlbumSpin1
onready var blackDrop = $Popup/Sprite/Blackdrop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_pos(value):
	value.rect_global_position.x = global_position.x
	value.rect_global_position.y = global_position.y - 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	spinning_album.call_deferred("queue_free")
	popup.popup()
	set_pos(popup)
	pop_timer.start()
	music_bars.show()
	music_found.show()
	blackDrop.show()
	text_2.hide()
	spinning_album_2.hide()
	

func _on_PopTimer1_timeout():
	music_bars.hide()
	music_found.hide()
	blackDrop.hide()
	text_2.show()
	spinning_album_2.show()
	
