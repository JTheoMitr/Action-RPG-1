extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const HopSound = preload("res://Music and Sounds/SpiderHopLow.tscn")
const SlimeLaser = preload("res://Enemies/SlimeLaserRightStraight.tscn")
const SlimeLaserTwo = preload("res://Enemies/SlimeLaserLeftStraight.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const Ammo = preload("res://World/Ammo.tscn")


export var ACCELERATION = 355
export var MAX_SPEED = 70
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

var dir := 1.0
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var timer = $Timer
onready var light = $Light2D
onready var tail = $AnimatedSprite2
onready var decoyBug = $AnimatedSprite3

var lightingUp
var lightingDown
func _ready():
	state = IDLE
	lightingDown = false
	lightingUp = true
	


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	light.energy = clamp(light.energy + dir * 0.8 * delta, 0.4, 1.2)
	if is_equal_approx(light.energy, 1.2):
		dir = -1.0
	elif is_equal_approx(light.energy, 0.4):
		dir = 1.0
		
	if tail.flip_h:
		tail.position.x = 37.0
		decoyBug.position.x = 123.0
		light.position.x = 126.5
	else:
		tail.position.x = -42.0
		decoyBug.position.x = -123.0
		light.position.x = -126.5
		
	
	
	match state:
		IDLE:
			sprite.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander_state()
				
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				
				
				
			else:
				state = IDLE
				
				

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	tail.flip_h = velocity.x > 0
	
	
	
func seek_player():
	if playerDetectionZone.can_see_player():
		var hopSound = HopSound.instance()
		get_parent().add_child(hopSound)
		hopSound.play(0.0)
		print_debug("timer start")
		sprite.play("attack")
		timer.start(0.0)
		state = CHASE
	else:
		timer.stop()
		sprite.play("idle")

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	# print(stats.health)
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	
	playerDetectionZone.scale.x = (playerDetectionZone.scale.x * 3)
	playerDetectionZone.scale.y = (playerDetectionZone.scale.y * 3)
	# state = WANDER

	
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	var xpOrb = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb)
	xpOrb.global_position = global_position
	var xpOrb2 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb2)
	xpOrb2.global_position = global_position
	xpOrb2.MAX_SPEED = 65
	var xpOrb3 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb3)
	xpOrb3.global_position = global_position
	xpOrb3.MAX_SPEED = 70
	var randomDrop = random_drop_generator(["ammo", "drop", "ammo"])
	if (randomDrop == "ammo"):
		var ammo = Ammo.instance()
		get_parent().call_deferred("add_child", ammo)
		ammo.global_position = global_position

	


func _on_Timer_timeout():
	# print_debug("boom")
	var laserTwo = SlimeLaserTwo.instance()
	var laser = SlimeLaser.instance()
	get_parent().call_deferred("add_child", laser)
	laser.global_position = global_position
	get_parent().call_deferred("add_child", laserTwo)
	laserTwo.global_position = global_position


func _on_Timer2_timeout():
	if lightingDown:
		lightingUp
	else:
		lightingDown
