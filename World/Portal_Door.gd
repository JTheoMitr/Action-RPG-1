extends StaticBody2D

const PortalSound = preload("res://Music and Sounds/LightningPortalSound.tscn")
const BloodSpatter = preload("res://Effects/BloodSpatterEffect1.tscn")
const BloodSpatter2 = preload("res://Effects/BloodSpatterEffect2.tscn")
const LungsToss = preload("res://Effects/LungsToss1.tscn")
const GutsToss = preload("res://Effects/GutsToss1.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var worldStats = WorldStats
onready var collisionShape = $CollisionShape2D
onready var save_data = SaveFile.g_data
onready var guardOne = $GuardOne
onready var base = $Sprite
onready var timer = $Timer
onready var timer2 = $Timer2
onready var collisionShape2 = $CollisionShape2D2
onready var skeleton = $AnimatedSprite2
onready var electricity = $Electricity
var guardAlive
var guardDirection

# Called when the node enters the scene tree for the first time.
func _ready():
	skeleton.hide()
	electricity.hide()
	guardOne.global_position.y = base.global_position.y
	guardOne.global_position.x = base.global_position.x + 20
	guardDirection = 0
	guardOne.frame = 0
	timer.start()
	timer2.start()
	worldStats.connect("portal_opened", self, "open_ses")
	if save_data.portal_1_opened == true:
		guardAlive = false
		guardOne.queue_free()
		collisionShape.queue_free()
		collisionShape2.queue_free()
		$AnimatedSprite.frame = 5
		$AnimatedSprite.stop()
		$LightningSpin.hide()
		$LightningSpin2.hide()
		$LightningSpin3.hide()
	else:
		guardAlive = true
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if guardAlive == true:
		skeleton.global_position = guardOne.global_position
		

#	pass
func open_ses():
	if guardAlive && save_data.portal_1_opened == false:
		$AnimatedSprite.play("default")
		collisionShape.queue_free()
		collisionShape2.queue_free()
		$Pop.play()
		var portalSound = PortalSound.instance()
		get_tree().current_scene.add_child(portalSound)
		var bloodSpatter = BloodSpatter.instance()
		get_parent().call_deferred("add_child", bloodSpatter)
		bloodSpatter.global_position = skeleton.global_position
	
		var bloodSpatter2 = BloodSpatter2.instance()
		get_parent().call_deferred("add_child", bloodSpatter2)
		bloodSpatter2.global_position.y = skeleton.global_position.y + 10
		bloodSpatter2.global_position.x = skeleton.global_position.x
	
		var lungsToss = LungsToss.instance()
		get_parent().call_deferred("add_child", lungsToss)
		lungsToss.global_position = skeleton.global_position
	
		var gutsToss = GutsToss.instance()
		get_parent().call_deferred("add_child", gutsToss)
		gutsToss.global_position.y = skeleton.global_position.y + 1
		gutsToss.global_position.x = skeleton.global_position.x - 2
	
		$Scream.play()
	
		guardAlive = false
		guardOne.queue_free()
		electricity.show()
		electricity.frame = 0
		electricity.play("default")
		skeleton.show()
		skeleton.frame = 0
		skeleton.play("default")


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.frame = 5
	$AnimatedSprite.stop()
	$LightningSpin.hide()
	$LightningSpin2.hide()
	$LightningSpin3.hide()
	save_data.portal_1_opened = true
	SaveFile.save_data()


func _on_Timer_timeout():
	#print_debug("timed")
	if guardDirection == 1:
		guardDirection = 0
	else:
		guardDirection = 1


func _on_AnimatedSprite2_animation_finished():
	skeleton.queue_free()


func _on_Electricity_animation_finished():
	electricity.queue_free()


func _on_Timer2_timeout():
	if guardAlive == true:
		if guardDirection == 0:
			guardOne.global_position.x -= 2
		else:
			guardOne.global_position.x += 2
