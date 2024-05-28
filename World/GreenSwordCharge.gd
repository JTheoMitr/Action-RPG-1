extends Area2D

const NewSkill = preload("res://Music and Sounds/NewSkill.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PopupDialog.rect_global_position = global_position



func _on_GreenSwordCharge_area_entered(area):
	PlayerStats.greenCharge = true
	PlayerStats.purpleCharge = false
	$Sprite.hide()
	$PopupDialog.show()
	$Timer.start()
	PlayerStats.emit_signal("green_charged")
	var newSkill = NewSkill.instance()
	get_tree().current_scene.add_child(newSkill)


func _on_Timer_timeout():
	$PopupDialog.hide()
	queue_free()
