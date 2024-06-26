extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Battery = preload("res://World/Battery.tscn")
const Ammo = preload("res://World/Ammo.tscn")
const SoldierSound = preload("res://Music and Sounds/SoldierSound.tscn")
const SoldierExplodeSound = preload("res://Music and Sounds/SoldierExplodeSound.tscn")
const Laser = preload("res://Enemies/DroidLaser.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const LaserSound = preload("res://Music and Sounds/LaserRifleSound.tscn")

export var ACCELERATION = 215
export var MAX_SPEED = 35
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var shootTimer = $ShootTimer

var worldStats = WorldStats
var looking = true




func _ready():
	state = pick_random_state([IDLE, WANDER])
	worldStats.connect("in_the_tall_grass", self, "cant_find_player")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			if looking:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				sprite.play("idle")
				if wanderController.get_time_left() == 0:
					update_wander_state()
				
		WANDER:
			if looking:
				sprite.play("walk")
				if wanderController.get_time_left() == 0:
					update_wander_state()
				accelerate_towards_point(wanderController.target_position, delta)
				if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
					update_wander_state()


	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 2))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()



