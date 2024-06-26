extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const FlutterSound = preload("res://Music and Sounds/FlutterSound.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")


export var ACCELERATION = 300
export var MAX_SPEED = 50
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

var flutterSound = FlutterSound.instance()



var worldStats = WorldStats

func _ready():
	state = pick_random_state([IDLE, WANDER])
	worldStats.connect("in_the_tall_grass", self, "cant_find_player")
	get_parent().call_deferred("add_child", flutterSound)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			sprite.play("idle")
			if wanderController.get_time_left() == 0:
				update_wander_state()
				
		WANDER:
			seek_player()
			sprite.play("fly")
			if wanderController.get_time_left() == 0:
				update_wander_state()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander_state()
				
		CHASE:
			sprite.play("fly")
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
		flutterSound.play(0.0)
		state = CHASE
		
func cant_find_player():
	state = IDLE

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	# print(stats.health)
	knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	playerDetectionZone.scale.x = (playerDetectionZone.scale.x * 3)
	playerDetectionZone.scale.y = (playerDetectionZone.scale.y * 3)


func _on_Stats_no_health():
	
	queue_free()
	flutterSound.stop()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	var xpOrb = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb)
	xpOrb.global_position = global_position
