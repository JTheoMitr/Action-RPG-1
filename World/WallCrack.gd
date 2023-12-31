extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup = $PopupDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	popup.rect_global_position = self.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	popup.show()


func _on_Area2D_area_exited(area):
	popup.hide()
