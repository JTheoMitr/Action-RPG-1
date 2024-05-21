extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const DroidBossDeathEffect = preload("res://Effects/DroidBossDeathAnim.tscn")
const Battery = preload("res://World/Battery.tscn")
const RobotCorpse = preload("res://Enemies/DeadDroidBoss.tscn")
const Laser = preload("res://Enemies/BossLaserBottomLeftStraight.tscn")
const LaserTwo = preload("res://Enemies/BossLaserTopRightStraight.tscn")
const LaserThree = preload("res://Enemies/BossLaserBottomRightStraight.tscn")
const LaserFour = preload("res://Enemies/BossLaserTopLeftStraight.tscn")
const LaserFive = preload("res://Enemies/BossLaserRightStraight.tscn")
const LaserSix = preload("res://Enemies/BossLaserLeftStraight.tscn")
const XpOrb = preload("res://Enemies/XpOrbLrg.tscn")
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
var frozen = false
var worldStats = WorldStats
var playerStats = PlayerStats
var songStarted = false

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
onready var laserTimer = $Timer3
onready var laserTimerTwo = $Timer4
onready var hitbox = $Hitbox/CollisionShape2D
onready var bossHealthUI = $CanvasLayer/DroidBossHealthUI
onready var armor1 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Armor_One
onready var armor2 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Armor_Two
onready var armor3 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Armor_Three
onready var armor4 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Armor_Four
onready var health1 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Health_One
onready var health2 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Health_Two
onready var health3 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Health_Three
onready var health4 = $CanvasLayer/DroidBossHealthUI/HBoxContainer/Health_Four
onready var timer5 = $Timer5

var introduced = false


func _ready():
	state = pick_random_state([IDLE, WANDER])
	bossHealthUI.hide()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	#bossHealthUI.rect_global_position.x = self.global_position.x - 10
	#bossHealthUI.rect_global_position.y = self.global_position.y - 55
	
	
	if frozen == true:
		velocity = Vector2.ZERO
		sprite.play("stagger")
		laserTimerTwo.start(0.0)
	
	match self.stats.health:
		8:
			health1.show()
			health2.show()
			health3.show()
			health4.show()
			armor1.show()
			armor2.show()
			armor3.show()
			armor4.show()
		7:
			armor4.hide()
		6:
			armor4.hide()
			armor3.hide()
		5:
			armor4.hide()
			armor3.hide()
			armor2.hide()
		4:
			armor4.hide()
			armor3.hide()
			armor2.hide()
			armor1.hide()
		3:
			armor4.hide()
			armor3.hide()
			armor2.hide()
			armor1.hide()
			health4.hide()
		2:
			armor4.hide()
			armor3.hide()
			armor2.hide()
			armor1.hide()
			health4.hide()
			health3.hide()
		1:
			armor4.hide()
			armor3.hide()
			armor2.hide()
			armor1.hide()
			health4.hide()
			health3.hide()
			health2.hide()
		0:
			armor4.hide()
			armor3.hide()
			armor2.hide()
			armor1.hide()
			health4.hide()
			health3.hide()
			health2.hide()
			health1.hide()
	
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
		if introduced == false:
			bossHealthUI.show()
			introduced = true
			$CanvasLayer/PopupDialog.show()
			playerStats.emit_signal("player_paused")
			self.MAX_SPEED = 0
			timer5.start()
		elif introduced == true:
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
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	var droidBossDeath = DroidBossDeathEffect.instance()
	var robotCorpse = RobotCorpse.instance()
	
	get_parent().add_child(enemyDeathEffect)
	get_parent().add_child(droidBossDeath)
	#get_parent().add_child(robotCorpse)
	get_parent().call_deferred("add_child", robotCorpse)
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
	
	#robotCorpse.global_position.x = global_position.x
	#robotCorpse.global_position.y = global_position.y + 2
	robotCorpse.global_position = global_position
	enemyDeathEffect.global_position = global_position
	droidBossDeath.global_position = global_position
	worldStats.emit_signal("fade_music_in")
	call_deferred("queue_free")
	var randomDrop = random_drop_generator(["drop", "none"])
	if (randomDrop == "drop"):
		var battery = Battery.instance()
		get_parent().call_deferred("add_child", battery)
		battery.global_position = global_position


func _on_Timer_timeout():
		atkHitbox.monitorable = true
		sprite.play("attack")


func _on_SoundTrigger_area_entered(area):
	if songStarted == false:
		$MechEngineSound.play()
		worldStats.emit_signal("fade_music_out")
		songStarted = true


func _on_Timer2_timeout():
	if frozen == false:
		frozen = true
		stagSound.play()
		laserTimer.start(0.0)
		atkHitbox.monitorable = false

	elif frozen == true:
		frozen = false
		atkHitbox.monitorable = true
		sprite.play("attack")
		laserTimer.stop()
	


func _on_SoundTrigger_area_exited(area):
	pass
	#worldStats.emit_signal("fade_music_in")


func _on_Timer3_timeout():
	
	var laserSound = BossLaserSound.instance()
	get_parent().call_deferred("add_child", laserSound)
	
	var laser = Laser.instance()
	get_parent().call_deferred("add_child", laser)
	laser.global_position = hitbox.global_position
	
	var laserTwo = LaserTwo.instance()
	get_parent().call_deferred("add_child", laserTwo)
	laserTwo.global_position = hitbox.global_position
	
	var laserThree = LaserThree.instance()
	get_parent().call_deferred("add_child", laserThree)
	laserThree.global_position = hitbox.global_position
	
	var laserFour = LaserFour.instance()
	get_parent().call_deferred("add_child", laserFour)
	laserFour.global_position = hitbox.global_position


func _on_Timer4_timeout():
	var laserFive = LaserFive.instance()
	get_parent().call_deferred("add_child", laserFive)
	laserFive.global_position = hitbox.global_position
	
	var laserSix = LaserSix.instance()
	get_parent().call_deferred("add_child", laserSix)
	laserSix.global_position = hitbox.global_position


func _on_Timer5_timeout():
	playerStats.emit_signal("player_resumed")
	self.MAX_SPEED = 50
	state = CHASE
	timer.start()
	$Timer2.start()
	$CanvasLayer/PopupDialog.hide()
