extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = $Timer
onready var timer2 = $Timer2
onready var hurtbox = $Hurtbox
onready var hitbox = $ProjectileHitbox

var playerStats = PlayerStats

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var reversePath = Vector2.ZERO
var input_vector = Vector2.ZERO


var FRICTION = 100

export var ACCELERATION = 350
export var MAX_SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position.y += 1
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


func _on_Timer_timeout():
	queue_free()




func _on_Hurtbox_area_entered(area):
	if playerStats.greenCharge == true:
		# stats.health -= area.damage
		timer2.start(0.0)
		reversePath = input_vector * 250
		# print_debug(hitbox.collision_mask)
		knockback = reversePath
		velocity = reversePath
		hurtbox.create_hit_effect()
		if input_vector.x == 0 && input_vector.y == 0:
			call_deferred("queue_free")


func _on_Timer2_timeout():
	hitbox.set_collision_mask_bit(6, true)
	hitbox.set_collision_mask_bit(2, false)
	# print_debug(hitbox.collision_mask)



func _on_ProjectileHitbox_area_entered(area):
	self.call_deferred("queue_free")
