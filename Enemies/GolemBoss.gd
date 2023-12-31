extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const GolemBossDeathEffect = preload("res://Effects/GolemBossDeathAnim.tscn")
const Battery = preload("res://World/Battery.tscn")
const GolemCorpse = preload("res://Enemies/DeadGolemBoss.tscn")
const Boulder = preload("res://Enemies/BoulderBaddie.tscn")

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
var frozen = false
var worldStats = WorldStats

var state = CHASE

onready var sprite = $AnimatedSprite
onready var shadow = $ShadowSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var atkHitbox = $Hitbox2
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var timer = $Timer
onready var stagSound = $StaggerSound
onready var breakSound = $BreakingSound

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	if frozen == true:
		velocity = Vector2.ZERO
		sprite.play("shield")

	
	match state:
		IDLE:
			atkHitbox.monitorable = false
			sprite.play("walk")
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
			#PlayerStats.overcharge = true
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
	if velocity.x < 0:
		# print(shadow.position.x)
		shadow.position.x = 40
	if velocity.x >= 0:
		shadow.position.x = 15
	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		timer.start()
		$Timer2.start()

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
	
	print(stats.health)
	knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	playerDetectionZone.scale.x = (playerDetectionZone.scale.x * 3)
	playerDetectionZone.scale.y = (playerDetectionZone.scale.y * 3)
	# print(atkHitbox.monitorable)


func _on_Stats_no_health():
	
	call_deferred("queue_free")
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	var golemBossDeath = GolemBossDeathEffect.instance()
	var golemCorpse = GolemCorpse.instance()
	
	get_parent().call_deferred("add_child", enemyDeathEffect)
	get_parent().call_deferred("add_child", golemBossDeath)
	get_parent().call_deferred("add_child", golemCorpse)
	
	golemCorpse.global_position.x = global_position.x - 22
	golemCorpse.global_position.y = global_position.y + 24
	enemyDeathEffect.global_position = global_position
	golemBossDeath.global_position = global_position
	
	var randomDrop = random_drop_generator(["drop", "none"])
	if (randomDrop == "drop"):
		var battery = Battery.instance()
		get_parent().add_child(battery)
		battery.global_position = global_position


func _on_Timer_timeout():

	var boulder = Boulder.instance()
	boulder.global_position = global_position
	get_parent().call_deferred("add_child", boulder)




func _on_SoundTrigger_area_entered(area):
	$GolemBossMusic.play()
	worldStats.call_deferred("emit_signal", "fade_music_out")


func _on_Timer2_timeout():
	if frozen == false:
		frozen = true
		stagSound.play(0.0)
		atkHitbox.monitorable = false

	else:
		frozen = false
		atkHitbox.monitorable = true
		if stats.health > 4:
			sprite.play("attack")
		if stats.health <= 4:
			sprite.play("blinking")
			breakSound.play(0.0)
	
	


func _on_SoundTrigger_area_exited(area):
	worldStats.call_deferred("emit_signal", "fade_music_in")
