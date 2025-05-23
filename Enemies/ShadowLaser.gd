extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const BloodSpatter = preload("res://Effects/BloodSpatterEffect1.tscn")


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
var reversePath = Vector2.ZERO
var input_vector = Vector2.ZERO

var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var timer = $Timer
onready var hitbox = $Hitbox
onready var timer2 = $Timer2

var playerStats = PlayerStats

func _ready():
	state = pick_random_state([IDLE, WANDER])
	timer.start(0.0)
	$Hitbox.damage = 3


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
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
		
		state = CHASE
		

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 2))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	if playerStats.purpleCharge == true:
		# stats.health -= area.damage
		timer2.start(0.0)
		reversePath = input_vector * 150
		# print_debug(hitbox.collision_mask)
		knockback = reversePath
		velocity = reversePath
		hurtbox.create_hit_effect()
		if input_vector.x == 0 && input_vector.y == 0:
			call_deferred("queue_free")
		



func _on_Stats_no_health():
	call_deferred("queue_free")
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position



func _on_Hitbox_area_entered(area):
	self.call_deferred("queue_free")
	var bSpatter = BloodSpatter.instance()
	get_parent().add_child(bSpatter)
	bSpatter.global_position = self.global_position
	


func _on_Timer_timeout():
	call_deferred("queue_free")



func _on_Timer2_timeout():
	hitbox.set_collision_mask_bit(6, true)
	hitbox.set_collision_mask_bit(2, false)
	# print_debug(hitbox.collision_mask)
	
