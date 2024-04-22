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
		state = CHASE
		timer.start()
		$Timer2.start()
		bossHealthUI.show()

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
	var xpOrb4 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb4)
	xpOrb4.global_position = global_position
	xpOrb4.MAX_SPEED = 63
	var xpOrb5 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb5)
	xpOrb5.global_position = global_position
	xpOrb5.MAX_SPEED = 60
	var xpOrb6 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb6)
	xpOrb6.global_position = global_position
	var xpOrb7 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb7)
	xpOrb7.global_position = global_position
	xpOrb7.MAX_SPEED = 66
	var xpOrb8 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb8)
	xpOrb8.global_position = global_position
	xpOrb8.MAX_SPEED = 71
	var xpOrb9 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb9)
	xpOrb9.global_position = global_position
	xpOrb9.MAX_SPEED = 64
	var xpOrb10 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb10)
	xpOrb10.global_position = global_position
	xpOrb10.MAX_SPEED = 61
	var xpOrb11 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb11)
	xpOrb11.global_position = global_position
	var xpOrb12 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb12)
	xpOrb12.global_position = global_position
	xpOrb12.MAX_SPEED = 62
	var xpOrb13 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb13)
	xpOrb13.global_position = global_position
	xpOrb13.MAX_SPEED = 65
	var xpOrb14 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb14)
	xpOrb14.global_position = global_position
	xpOrb14.MAX_SPEED = 58
	var xpOrb15 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb15)
	xpOrb15.global_position = global_position
	xpOrb15.MAX_SPEED = 73
	var xpOrb16 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb16)
	xpOrb16.global_position = global_position
	var xpOrb17 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb17)
	xpOrb17.global_position = global_position
	xpOrb17.MAX_SPEED = 69
	var xpOrb18 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb18)
	xpOrb18.global_position = global_position
	xpOrb18.MAX_SPEED = 71
	var xpOrb19 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb19)
	xpOrb19.global_position = global_position
	xpOrb19.MAX_SPEED = 68
	var xpOrb20 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb20)
	xpOrb20.global_position = global_position
	xpOrb20.MAX_SPEED = 60
	var xpOrb21 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb21)
	xpOrb21.global_position = global_position
	var xpOrb22 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb22)
	xpOrb22.global_position = global_position
	xpOrb22.MAX_SPEED = 65
	var xpOrb23 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb23)
	xpOrb23.global_position = global_position
	xpOrb23.MAX_SPEED = 74
	var xpOrb24 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb24)
	xpOrb24.global_position = global_position
	xpOrb24.MAX_SPEED = 63
	var xpOrb25 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb25)
	xpOrb25.global_position = global_position
	xpOrb25.MAX_SPEED = 60
	var xpOrb26 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb26)
	xpOrb26.global_position = global_position
	var xpOrb27 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb27)
	xpOrb27.global_position = global_position
	xpOrb27.MAX_SPEED = 65
	var xpOrb28 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb28)
	xpOrb28.global_position = global_position
	xpOrb28.MAX_SPEED = 70
	var xpOrb29 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb29)
	xpOrb29.global_position = global_position
	xpOrb29.MAX_SPEED = 63
	var xpOrb30 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb30)
	xpOrb30.global_position = global_position
	xpOrb30.MAX_SPEED = 60
	#robotCorpse.global_position.x = global_position.x
	#robotCorpse.global_position.y = global_position.y + 2
	robotCorpse.global_position = global_position
	enemyDeathEffect.global_position = global_position
	droidBossDeath.global_position = global_position
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
	$MechEngineSound.play()
	worldStats.emit_signal("fade_music_out")


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
	worldStats.emit_signal("fade_music_in")


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
