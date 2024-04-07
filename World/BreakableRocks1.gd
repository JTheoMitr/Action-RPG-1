extends Area2D


onready var rock1 = $BR1
onready var rock2 = $BR2
onready var rock3 = $BR3
onready var brock1 = $Broken1
onready var brock2 = $Broken2
onready var brock3 = $Broken3


# Called when the node enters the scene tree for the first time.
func _ready():
	rock1.show()
	rock2.show()
	rock3.show()
	brock1.hide()
	brock2.hide()
	brock3.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BreakableRocks1_area_entered(area):
	rock1.hide()
	rock2.hide()
	rock3.hide()
	brock1.show()
	brock2.show()
	brock3.show()
