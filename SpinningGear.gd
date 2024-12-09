extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spinFast
onready var whir = $Whir
onready var smoke = $Smoke
onready var hiss = $Hiss

# Called when the node enters the scene tree for the first time.
func _ready():
	spinFast = false
	smoke.hide()
	smoke.stop()
	smoke.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("laser"):
		spinFast = true
		whir.play()
	if Input.is_action_just_released("laser"):
		spinFast = false
		whir.stop()
		smoke.show()
		smoke.play("default")
		hiss.play()
	
	if spinFast == false:
		self.rotation_degrees += 2
	if spinFast:
		self.rotation_degrees += 10
	
	if rotation_degrees >= 360:
		self.rotation_degrees = 0


func _on_Smoke_animation_finished():
	smoke.hide()
	smoke.stop()
	smoke.frame = 0
