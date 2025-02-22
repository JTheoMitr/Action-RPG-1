extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var up = false
export var damage = 1
const HitEffect = preload("res://Effects/HitEffect.tscn")
const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")
#spinningBot movement
#rotations
var left
var right
var chaos
#paths after being struck
var movingUp
var movingDown
var movingLeft
var movingRight

onready var hurtbox = $Area2D2
onready var timer3 = $Timer3
onready var ohNo = $Ohno
onready var endTimer = $Timer4

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$Timer2.start()
	$Buzz.volume_db = -90
	left = false
	right = true
	movingDown = false
	movingLeft = false
	movingRight = false
	movingUp = false
	self.rotation_degrees -= 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left:
		self.rotation_degrees += 6
	if right:
		self.rotation_degrees -= 6
	if chaos:
		self.rotation_degrees += 5
		
	if movingUp:
		self.global_position.y -= 1
	if movingDown:
		self.global_position.y += 1
	if movingRight:
		self.global_position.x += 1
	if movingLeft:
		self.global_position.x -= 1


func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Timer2_timeout():
	
	if up == false:
		global_position.y += 2
	else:
		global_position.y -= 2


func _on_Timer_timeout():
	$Buzz.play()
	if up == false:
		up = true
	else:
		up = false
		


func _on_Area2D_area_entered(area):
	$Buzz.volume_db = -20
	


func _on_Area2D_area_exited(area):
	$Buzz.volume_db = -90


func _on_Timer3_timeout():
	if left:
		right = true
		left = false
	else:
		left = true
		right = false


func _on_Area2D2_area_entered(area): #hurtbox
	timer3.stop()
	right = false
	left = false
	chaos = true
	endTimer.start(0.0)
	
	var effect = HitEffect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	ohNo.play(0.0)
	
	movingUp = true
	yield(get_tree().create_timer(0.3), "timeout")
	movingUp = false
	movingLeft = true
	yield(get_tree().create_timer(0.3), "timeout")
	movingLeft = false
	movingDown = true
	yield(get_tree().create_timer(0.3), "timeout")
	movingDown = false
	movingRight = true
	yield(get_tree().create_timer(0.3), "timeout")
	movingRight = false
	movingUp = true
	yield(get_tree().create_timer(0.3), "timeout")
	movingUp = false
	movingLeft = true
	yield(get_tree().create_timer(0.3), "timeout")
	movingLeft = false
	movingDown = true
	
	# next steps: add new "whoa" audio with buzzing low, timer for queue free, and an explosion
	


func _on_Timer4_timeout():
	queue_free()
	var explosion = ExplosionEffect.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
