extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var treeSprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_IndexArea_area_entered(area):
	treeSprite.z_index = 1


func _on_IndexArea_area_exited(area):
	treeSprite.z_index = 0
