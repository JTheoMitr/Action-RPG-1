extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Battery = preload("res://World/Battery.tscn")
const Ammo = preload("res://World/Ammo.tscn")
const SoldierSound = preload("res://Music and Sounds/ShadowSound.tscn")
const SoldierExplodeSound = preload("res://Music and Sounds/SoldierExplodeSound.tscn")
const Laser = preload("res://Enemies/ShadowLaser.tscn")
const LaserSound = preload("res://Music and Sounds/ShadowLaserSound.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const BloodSpatter = preload("res://Effects/BloodSpatterEffect1.tscn")
const OilTrail = preload("res://World/OilTrail.tscn")
const OilTrailSmall = preload("res://World/OilTrailSmall.tscn")
const OilSpatter = preload("res://World/OilTrailSpatter.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 90
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
var laserEngaged = false
var hurtable = true

onready var trailZone = $TrailZone
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var timer = $Timer
onready var hitbox = $Hitbox/CollisionShape2D
onready var bulletZone2D = $BulletZone2D/CollisionShape2D
onready var shootTimer = $ShootTimer
onready var trailTimer = $TrailTimer

var worldStats = WorldStats
var looking = true
var shooting = false
var dead = false



func _ready():
	state = pick_random_state([IDLE, WANDER])
	worldStats.connect("in_the_tall_grass", self, "cant_find_player")
	self.stats.max_health = 3
	self.stats.health = 3
	hitbox.set_deferred("disabled", true)
	trailTimer.start()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	if shooting:
		#velocity.x = 0
		#velocity.y = 0
		self.MAX_SPEED = 0
		self.FRICTION = 500

	
	match state:
		IDLE:
			if looking:
				timer.stop()
				
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				seek_player()
				sprite.play("idle")
				if wanderController.get_time_left() == 0:
					update_wander_state()
				
		WANDER:
			if looking:
				
				seek_player()
				sprite.play("walk")
				if wanderController.get_time_left() == 0:
					update_wander_state()
				accelerate_towards_point(wanderController.target_position, delta)
				if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
					update_wander_state()
				
		CHASE:
			if looking:
				
				var player = playerDetectionZone.player
				if player != null:
					if shooting == false:
						sprite.play("walk")
						accelerate_towards_point(player.global_position, delta)
				else:
					state = IDLE
					sprite.play("idle")

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	if sprite.flip_h:
		# print(shadow.position.x)
		bulletZone2D.position.x = -9
	if !sprite.flip_h:
		bulletZone2D.position.x = 9
	

	

func seek_player():
	sprite.play("walk")
	if playerDetectionZone.can_see_player() && looking:
		var soldierSound = SoldierSound.instance()
		get_parent().add_child(soldierSound)
		soldierSound.play(0.0)
		state = CHASE
	else:
		timer.stop()
		
		
		
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
	if hurtable:
		stats.health -= area.damage
		# print_debug("hit")
		#if area.knockback_vector != null:
			#knockback = area.knockback_vector * 130
		hurtbox.create_hit_effect()
		playerDetectionZone.scale.x = (playerDetectionZone.scale.x * 3)
		playerDetectionZone.scale.y = (playerDetectionZone.scale.y * 3)


func _on_Stats_no_health():
	looking = false
	hurtable = false
	dead = true
	velocity.x = 0
	velocity.y = 0
	hitbox.call_deferred("queue_free")
	timer.stop()
	sprite.play("death")
	var soldierExplode = SoldierExplodeSound.instance()
	get_parent().add_child(soldierExplode)
	$Timer2.start()


func _on_Timer_timeout():
	var laser = Laser.instance()
	get_parent().call_deferred("add_child", laser)
	laser.global_position = bulletZone2D.global_position
	
	var laserSound = LaserSound.instance()
	get_parent().call_deferred("add_child", laserSound)
	#var bSpatter = BloodSpatter.instance()
	#get_parent().add_child(bSpatter)
	#bSpatter.global_position = bulletZone2D.global_position
	#add laser sound and determine if you need to trigger from animation
	#duplicate bat after you finish and make a basic wandering droid



func _on_Timer2_timeout():
	call_deferred("queue_free")
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
	var randomDrop = random_drop_generator(["drop", "none", "drop"])
	if (randomDrop == "drop"):
		var battery = Battery.instance()
		get_parent().call_deferred("add_child", battery)
		battery.global_position = global_position


func _on_ShootTimer_timeout():
	pass # sprite.play("shoot")


func _on_Area2D_area_entered(area):
	if dead == false:
		sprite.play("shoot")
		shooting = true
		timer.start(0.0)
		
		


func _on_Area2D_area_exited(area):
	state = CHASE
	shooting = false
	timer.stop()
	self.MAX_SPEED = 90
	self.FRICTION = 200


func _on_TrailTimer_timeout():
	var TrailDrop = random_drop_generator([OilTrail, OilTrailSmall, OilSpatter])
	var currentDrop = TrailDrop.instance()
	get_parent().call_deferred("add_child", currentDrop)
	currentDrop.global_position = trailZone.global_position
	#print_debug("dropping")
	
