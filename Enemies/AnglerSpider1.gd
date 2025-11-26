extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const HopSound = preload("res://Music and Sounds/AnglerScorpionSound1.tscn")
const SquishSound = preload("res://Music and Sounds/SquishSound.tscn")
const SquishSound2 = preload("res://Music and Sounds/BigSquishSound1.tscn")
const WhooshSound = preload("res://Music and Sounds/WhooshSound1.tscn")
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const Ammo = preload("res://World/Ammo.tscn")


export var ACCELERATION = 355
export var MAX_SPEED = 70
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

var dir := 1.0
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var hitbox = $Hitbox/CollisionShape2D
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Heart/Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var light = $Light2D
onready var tail = $AnimatedSprite2
onready var decoyBug = $AnimatedSprite3
onready var skull = $Sprite
onready var skull2 = $Skull2
onready var green_blood = $AnimatedSprite2/GreenBlood
onready var smoke_reveal = $SmokeReveal
onready var heart = $Heart
onready var blood_explosion = $Bloodsplosion

var lightingUp
var lightingDown
var awoken
var spinning_skull
func _ready():
	state = IDLE
	#lightingDown = false
	#lightingUp = true
	decoyBug.play("default")
	awoken = false
	green_blood.hide()
	tail.hide()
	sprite.hide()
	skull.hide()
	heart.hide()
	smoke_reveal.hide()
	smoke_reveal.frame = 0
	blood_explosion.hide()
	blood_explosion.frame = 0
	hitbox.disabled = false
	spinning_skull = false
	skull2.hide()
	


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	if lightingDown:
		skull.position.y = -12.0
	if lightingUp:
		skull.position.y = -13.0
		
	if spinning_skull:
		skull2.show()
		skull2.rotation_degrees -= 3
		skull2.position.y += 1
	if spinning_skull == false:
		skull2.global_position = skull.global_position
	
	light.energy = clamp(light.energy + dir * 0.8 * delta, 0.4, 1.2)
	if is_equal_approx(light.energy, 1.2):
		dir = -1.0
	elif is_equal_approx(light.energy, 0.4):
		dir = 1.0
		
	if tail.flip_h:
		tail.position.x = -14.0
		decoyBug.position.x = 25.0
		light.position.x = 25.0
		skull.position.x = 18.0
		skull.rotation_degrees = 350
		heart.position.x = -1.0
		heart.rotation_degrees = 330
		green_blood.position.x = 30.0
	else:
		tail.position.x = 22.0
		decoyBug.position.x = -25.0
		light.position.x = -25.0
		skull.position.x = -3
		skull.rotation_degrees = 10
		heart.position.x = 12
		heart.rotation_degrees = 30
		green_blood.position.x = -30.0
		
	
	
	match state:
		IDLE:
			sprite.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				if awoken:
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
	sprite.flip_h = velocity.x > 0
	tail.flip_h = velocity.x > 0
	skull.flip_h = velocity.x < 0
	
	
	
	
func seek_player():
	sprite.play("attack")
	if playerDetectionZone.can_see_player():
		tail.show()
		skull.show()
		heart.show()
		sprite.show()
		var hopSound = HopSound.instance()
		get_parent().add_child(hopSound)
		hopSound.play(0.0)
		print_debug("timer start")
		#timer.start(0.0)
		state = CHASE
	else:
		pass
		

func update_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	# print(stats.health)
	#spinning_skull = true
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	


	
func _on_Stats_no_health():
	sprite.hide()
	tail.hide()
	skull.hide()
	spinning_skull = true
	heart.hide()
	light.hide()
	green_blood.hide()
	decoyBug.hide()
	hitbox.set_deferred("disabled", true)
	
	var squishSound = SquishSound2.instance()
	get_parent().add_child(squishSound)
	squishSound.play(0.0)
	blood_explosion.show()
	blood_explosion.play()
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
	var randomDrop = random_drop_generator(["ammo", "drop", "ammo"])
	if (randomDrop == "ammo"):
		var ammo = Ammo.instance()
		get_parent().call_deferred("add_child", ammo)
		ammo.global_position = global_position

	





func _on_BugArea_area_entered(area):
	if awoken == false:
		smoke_reveal.show()
		smoke_reveal.play()
		var squishSound = SquishSound.instance()
		get_parent().add_child(squishSound)
		squishSound.play(0.0)
		var whooshSound = WhooshSound.instance()
		get_parent().add_child(whooshSound)
		whooshSound.play(0.0)
		playerDetectionZone.scale.x += 3.0
		playerDetectionZone.scale.y += 3.0
		awoken = true
		decoyBug.play("bleed")
		green_blood.show()
		tail.show()
		sprite.show()
		skull.show()
		heart.show()
	
	#play an effect and sound


func _on_SmokeReveal_animation_finished():
	smoke_reveal.queue_free()


func _on_Bloodsplosion_animation_finished():
	queue_free()
