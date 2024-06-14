extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hurtArea = $SpearHitBox/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	hurtArea.disabled = true
	frame = 0
	$Whoosh.volume_db = -90


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpearTrap_animation_finished():
	self.stop()
	hurtArea.disabled = true
	frame = 0
	


func _on_Timer_timeout():
	self.play("default")
	$Whoosh.play()
	$Timer2.start()


func _on_Timer2_timeout():
	hurtArea.disabled = false


func _on_Area2D_area_entered(area):
	$Whoosh.volume_db = -20


func _on_Area2D_area_exited(area):
	$Whoosh.volume_db = -90
