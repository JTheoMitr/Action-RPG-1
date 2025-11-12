extends StaticBody2D

onready var popup = $Popup
onready var timer = $Timer
onready var placement = $Placement
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	popup.popup()
	popup.rect_global_position.x = placement.global_position.x
	popup.rect_global_position.y = placement.global_position.y
	timer.start()
	print_debug("map_station_found")


func _on_Timer_timeout():
	popup.hide()
