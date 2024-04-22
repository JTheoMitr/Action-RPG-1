extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Battery = preload("res://World/Battery.tscn")
const SecDroidSound = preload("res://Music and Sounds/SecurityDroidSound.tscn")
const DroneSound = preload("res://Music and Sounds/DroneSound.tscn")
const Laser = preload("res://Enemies/BossLaserBottomLeftStraight.tscn")
const LaserTwo = preload("res://Enemies/BossLaserTopRightStraight.tscn")
const LaserThree = preload("res://Enemies/BossLaserBottomRightStraight.tscn")
const LaserFour = preload("res://Enemies/BossLaserTopLeftStraight.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const BossLaserSound = preload("res://Music and Sounds/BossLaserSound.tscn")

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

var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var hitbox2 = $Hitbox2
onready var timer = $Timer

var laserEngaged = false
var droneSound = DroneSound.instance()
var worldStats = WorldStats

func _ready():
	state = pick_random_state([IDLE, WANDER])
	worldStats.connect("in_the_tall_grass", self, "cant_find_player")
	
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if (sprite.frame == 5 || sprite.frame == 6 || sprite.frame == 7):
		hitbox2.monitorable = true
	else:
		hitbox2.monitorable = false
	
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
	if playerDetectionZone.can_see_player():
		var droidSound = SecDroidSound.instance()
		get_parent().call_deferred("add_child", droidSound)
		droidSound.play(0.0)
		get_parent().call_deferred("add_child", droneSound)
		droneSound.play(0.0)
		timer.start(0.0)
			# laserEngaged = true
		state = CHASE
	else:
		timer.stop()
		
		
func cant_find_player():
	state = IDLE
	
		

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	# print(stats.health)
	knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	playerDetectionZone.scale.x = (playerDetectionZone.scale.x * 3)
	playerDetectionZone.scale.y = (playerDetectionZone.scale.y * 3)


func _on_Stats_no_health():
	droneSound.call_deferred("queue_free")
	self.call_deferred("queue_free")
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
	var xpOrb4 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb4)
	xpOrb4.global_position = global_position
	xpOrb4.MAX_SPEED = 63
	var xpOrb5 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb5)
	xpOrb5.global_position = global_position
	xpOrb5.MAX_SPEED = 60
	var randomDrop = random_drop_generator(["drop", "none"])
	if (randomDrop == "drop"):
		var battery = Battery.instance()
		get_parent().call_deferred("add_child", battery)
		battery.global_position = global_position


func _on_Timer_timeout():
	
	var laserSound = BossLaserSound.instance()
	get_parent().call_deferred("add_child", laserSound)
	
	var laser = Laser.instance()
	get_parent().call_deferred("add_child", laser)
	laser.global_position = global_position
	
	var laserTwo = LaserTwo.instance()
	get_parent().call_deferred("add_child", laserTwo)
	laserTwo.global_position = global_position
	
	var laserThree = LaserThree.instance()
	get_parent().call_deferred("add_child", laserThree)
	laserThree.global_position = global_position
	
	var laserFour = LaserFour.instance()
	get_parent().call_deferred("add_child", laserFour)
	laserFour.global_position = global_position
