extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const GolemBossDeathEffect = preload("res://Effects/GolemBossDeathAnim.tscn")
const Battery = preload("res://World/Battery.tscn")
const GolemCorpse = preload("res://Enemies/DeadGolemBoss.tscn")
const Boulder = preload("res://Enemies/BoulderBaddie.tscn")
const XpOrb = preload("res://Enemies/XpOrbLrg.tscn")
const Explosion = preload("res://Inventory/Explosion.tscn")


export var ACCELERATION = 280
export var MAX_SPEED = 40
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE,
	STUN
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var frozen = false
var enraged = false
var reunited = false
var worldStats = WorldStats
var playerStats = PlayerStats
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
onready var timer2 = $Timer2
onready var timer3 = $Timer3
onready var stagSound = $StaggerSound
onready var breakSound = $BreakingSound
onready var bossHealthUI = $CanvasLayer/GolemBossHealthUI
onready var armor1 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Armor_One
onready var armor2 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Armor_Two
onready var armor3 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Armor_Three
onready var armor4 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Armor_Four
onready var health1 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Health_One
onready var health2 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Health_Two
onready var health3 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Health_Three
onready var health4 = $CanvasLayer/GolemBossHealthUI/HBoxContainer/Health_Four
onready var guitarBlast = $AudioStreamPlayer
onready var casinoDing = $AudioStreamPlayer2
onready var dust3 = $DustAnimation3
onready var dust4 = $DustAnimation4
onready var dust5 = $DustAnimation5
onready var timer4 = $Timer4

func _ready():
	state = pick_random_state([IDLE, WANDER])
	bossHealthUI.hide()
	hurtbox.monitoring = false
	dust3.hide()
	dust4.hide()
	dust5.hide()
	playerDetectionZone.monitoring = false
	playerDetectionZone.monitorable = false

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	if frozen == true:
		velocity = Vector2.ZERO
		sprite.play("shield")
	
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
			dust3.hide()
			dust4.hide()
			dust5.hide()
			atkHitbox.monitorable = false
			sprite.play("walk")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
				
		WANDER:
			dust3.hide()
			dust4.hide()
			dust5.hide()
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander_state()
				
		CHASE:
			dust3.hide()
			dust4.hide()
			dust5.hide()
			var player = playerDetectionZone.player
			#PlayerStats.overcharge = true
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
		STUN:
			sprite.play("stagger")
			atkHitbox.monitorable = false
			dust3.show()
			dust4.show()
			dust5.show()

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
		timer2.start()
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
	$CanvasLayer/PopupDialog/RichTextLabel.bbcode_text = "[center]It...can't be[/center]"
	$CanvasLayer/PopupDialog.show()
	self.MAX_SPEED = 0
	playerStats.emit_signal("player_paused")
	$Timer5.start()
	dust3.show()
	dust4.show()
	dust5.show()
	
	


func _on_Timer_timeout():

	var boulder = Boulder.instance()
	boulder.global_position = global_position
	get_parent().call_deferred("add_child", boulder)




func _on_SoundTrigger_area_entered(area):
	if reunited == false:
		playerStats.emit_signal("player_paused")
		$CanvasLayer/PopupDialog/RichTextLabel.bbcode_text = "[center] I'm impressed, old friend... [/center]"
		$CanvasLayer/PopupDialog.show()
		$GolemBossMusic.play()
		worldStats.call_deferred("emit_signal", "fade_music_out")
		$Timer6.start()
		self.MAX_SPEED = 0
		reunited = true
	


func _on_Timer2_timeout():
	if frozen == false:
		frozen = true
		stagSound.play(0.0)
		atkHitbox.monitorable = false

	else:
		frozen = false
		atkHitbox.monitorable = true
		if stats.health > 3:
			sprite.play("attack")
		if stats.health <= 3:
			sprite.play("blinking")
			breakSound.play(0.0)
	
	


func _on_SoundTrigger_area_exited(area):
	pass
	#worldStats.call_deferred("emit_signal", "fade_music_in")


func _on_StaggerArea_area_entered(area):
	#print_debug("Stagger")
	if stats.health > 4:
		velocity = Vector2.ZERO
		state = STUN
		timer.stop()
		timer2.stop()
		hurtbox.monitoring = true
		timer3.start()
		guitarBlast.play(0.0)
		casinoDing.play(0.0)
	else:
		velocity = Vector2.ZERO
		state = STUN
		timer.stop()
		timer2.stop()
		hurtbox.monitoring = true
		timer3.start()
		guitarBlast.play(0.0)
		casinoDing.play(0.0)
	
	


func _on_Timer3_timeout():
	state = CHASE
	guitarBlast.stop()
	casinoDing.stop()
	timer.start()
	timer2.start()
	hurtbox.monitoring = false
	
	if stats.health <= 4:
		timer4.start()
		if enraged == false:
			timer.stop()
			timer2.stop()
			self.MAX_SPEED = 0
			playerStats.emit_signal("player_paused")
			$CanvasLayer/PopupDialog/RichTextLabel.bbcode_text = "[center] Behold...My True Power! [/center]"
			$CanvasLayer/PopupDialog.show()
	


func _on_Timer4_timeout():
	
	if enraged == false:
		self.MAX_SPEED = 95
		playerStats.emit_signal("player_resumed")
		$CanvasLayer/PopupDialog.hide()
		timer.start()
		timer2.start()
		enraged = true
		worldStats.emit_signal("rage_mode")

func _on_Timer5_timeout():
	
	$CanvasLayer/PopupDialog.hide()
	playerStats.emit_signal("player_resumed")
	worldStats.call_deferred("emit_signal", "fade_music_in")
	var enemyDeathEffect = EnemyDeathEffect.instance()
	var golemBossDeath = GolemBossDeathEffect.instance()
	var golemCorpse = GolemCorpse.instance()
	var explosion = Explosion.instance()
	get_parent().call_deferred("add_child", explosion)
	explosion.global_position = global_position
	$Timer8.start()
	$Timer9.start()

	get_parent().call_deferred("add_child", enemyDeathEffect)
	get_parent().call_deferred("add_child", golemBossDeath)
	get_parent().call_deferred("add_child", golemCorpse)
	
	golemCorpse.global_position = global_position
	enemyDeathEffect.global_position = global_position
	golemBossDeath.global_position = global_position
	
	var randomDrop = random_drop_generator(["drop", "none"])
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
	if (randomDrop == "drop"):
		var battery = Battery.instance()
		get_parent().add_child(battery)
		battery.global_position = global_position


func _on_Timer6_timeout():
	$Timer7.start()
	$CanvasLayer/PopupDialog/RichTextLabel.bbcode_text = "[center] But you'll go no further. [/center]"
	


func _on_Timer7_timeout():
	$CanvasLayer/PopupDialog.hide()
	playerStats.emit_signal("player_resumed")
	self.MAX_SPEED = 65
	playerDetectionZone.monitoring = true
	playerDetectionZone.monitorable = true


func _on_Timer8_timeout():
	var explosion = Explosion.instance()
	get_parent().call_deferred("add_child", explosion)
	explosion.global_position = dust5.global_position


func _on_Timer9_timeout():
	var explosion = Explosion.instance()
	call_deferred("queue_free")
	get_parent().call_deferred("add_child", explosion)
	explosion.global_position = dust3.global_position
