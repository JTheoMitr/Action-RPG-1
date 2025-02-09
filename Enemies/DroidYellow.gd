extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Battery = preload("res://World/Battery.tscn")
const Ammo = preload("res://World/Ammo.tscn")
const DroidSound = preload("res://Music and Sounds/DroidSound.tscn")
const Laser = preload("res://Enemies/DroidLaser.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const OilTrail = preload("res://World/OilTrail.tscn")
const OilTrailSmall = preload("res://World/OilTrailSmall.tscn")
const OilSpatter = preload("res://World/OilTrailSpatter.tscn")
const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")

export var ACCELERATION = 280
export var MAX_SPEED = 40
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var worldStats = WorldStats

var state = CHASE
var laserEngaged = false


onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var trailZone = $TrailZone


func _ready():
	state = pick_random_state([IDLE, WANDER])
	worldStats.connect("in_the_tall_grass", self, "cant_find_player")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			
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
	sprite.flip_h = velocity.x < 0
	

	

func seek_player():
	sprite.play("walk")
	if playerDetectionZone.can_see_player():
		var droidSound = DroidSound.instance()
		get_parent().add_child(droidSound)
		droidSound.play(0.0)

		state = CHASE

		
func cant_find_player():
	state = IDLE
		

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 2))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	playerDetectionZone.scale.x = (playerDetectionZone.scale.x * 3)
	playerDetectionZone.scale.y = (playerDetectionZone.scale.y * 3)


func _on_Stats_no_health():
	call_deferred("queue_free")
	var explosion = ExplosionEffect.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
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
	var randomDrop = random_drop_generator(["ammo", "ammo", "ammo"])
	if (randomDrop == "ammo"):
		var ammo = Ammo.instance()
		get_parent().call_deferred("add_child", ammo)
		ammo.global_position = global_position
	



func _on_Timer_timeout():
	pass


func _on_TrailTimer_timeout():
	var TrailDrop = random_drop_generator([OilTrail, OilTrailSmall, OilSpatter])
	var currentDrop = TrailDrop.instance()
	get_parent().call_deferred("add_child", currentDrop)
	currentDrop.global_position = trailZone.global_position
	#print_debug("dropping")
