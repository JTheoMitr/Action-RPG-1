extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const EnemyGoreEffect = preload("res://Effects/BloodSpatterEffect1.tscn")
const Battery = preload("res://World/Battery.tscn")
const Ammo = preload("res://World/Ammo.tscn")
const DwellerSound = preload("res://Music and Sounds/DwellerSound.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")

export var ACCELERATION = 280
export var MAX_SPEED = 75
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



func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			sprite.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
				
		WANDER:
			seek_player()
			sprite.play("walk")
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
		var dwellerSound = DwellerSound.instance()
		get_parent().add_child(dwellerSound)
		dwellerSound.play(0.0)
		state = CHASE
		sprite.play("walk")
		

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
	var enemyGoreEffect = EnemyGoreEffect.instance()
	get_parent().add_child(enemyGoreEffect)
	enemyGoreEffect.global_position = global_position
	var enemyDeathEffect2 = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect2)
	enemyDeathEffect2.global_position = global_position
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
	var randomDrop = random_drop_generator(["drop", "none"])
	if (randomDrop == "drop"):
		var battery = Battery.instance()
		get_parent().call_deferred("add_child", battery)
		battery.global_position = global_position


func _on_TorchArea_area_entered(area):
	sprite.play("attack")
	

func _on_TorchArea_area_exited(area):
	sprite.play("walk")
	state = CHASE
