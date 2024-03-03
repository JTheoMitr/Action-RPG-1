extends Area2D


# Declare member variables here. Examples:
# var a = 2
var worldStats = WorldStats


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TallGrass_area_entered(area):
	worldStats.emit_signal("in_the_tall_grass")
	
	


func _on_TallGrass_area_exited(area):
	worldStats.emit_signal("out_of_the_tall_grass")
	
