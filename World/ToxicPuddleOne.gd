extends Sprite

const Slime = preload("res://Enemies/Slime.tscn")
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
	var slime = Slime.instance()
	get_parent().call_deferred("add_child", slime)
	slime.global_position = $Area2D/CollisionShape2D.global_position
