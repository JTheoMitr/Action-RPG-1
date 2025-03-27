extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const ElectricSound = preload("res://Music and Sounds/SpecialOneSound.tscn")
const FootstepOne = preload("res://Music and Sounds/Footstep1.tscn")
const FootstepTwo = preload("res://Music and Sounds/Footstep2.tscn")
const FootstepThree = preload("res://Music and Sounds/Footstep3.tscn")
const PauseSound = preload("res://Music and Sounds/PauseSound.tscn")
const LaserSound = preload("res://Music and Sounds/LaserSound.tscn")
const KnifeSound = preload("res://Music and Sounds/KnifeSound.tscn")
const ZoomCloud = preload("res://Effects/ZoomCloud.tscn")

onready var playerSpritePurple = preload("res://Player/Main Player One Ranger Helmet GREEN three lighteroutline.png")
onready var playerSpriteGreen = preload("res://Player/Main Player One Ranger Helmet GREEN three lighteroutline GREEN SWORD.png")
onready var playerSpriteRed = preload("res://Player/Main Player One Ranger Helmet GREEN three lighteroutline RED SWORD.png")
onready var save_file = SaveFile.g_data

signal fired_shot

export var ACCELERATION = 650
export var MAX_SPEED = 90
export var ROLL_SPEED = 115
export var FRICTION = 500

onready var animationPlayer = $AnimationPlayer
onready var playerCollision = $PlayerCollision
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var specialOne = $SpecialOneSprite
onready var swordSwiper = $SwordSwiper
onready var rollSounds = $RollSounds
onready var timer = $Timer
onready var blastZone = $SpecialOneSprite/SpecialAttackArea/CollisionShape2D
onready var playerInventory = $PlayerInventory
onready var button = $PlayerInventory/Control/CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/Consumables
onready var pointer = $Pointer
onready var ray = $Pointer/RayCast2D
onready var laserSprite = $Pointer/Sprite
onready var crosshair = $Pointer/crosshair
onready var laserTwo = $Pointer/Sprite2
onready var laserTimer = $Pointer/LaserTimer
onready var laserSpeed = $Pointer/LaserSpeed
onready var laserZone = $Pointer/Sprite/LaserZone/CollisionShape2D
onready var sprite = $PlayerSprite
onready var chargeTimer = $ChargeTimer
onready var playerSpriteSpecials = $PlayerSpriteSpecials
onready var playerSpriteHit = $PlayerSpriteHIT
onready var aura = $Aura
onready var zoomTimer = $ZoomTimer
onready var zoomOffTimer = $ZoomOffTimer
onready var zoomSound = $ZoomSound
onready var hitSpriteTimer = $HitSpriteTimer
onready var heartbeat = $HeartBeat
onready var heartBeatTimer = $HeartBeatTimer
onready var spinningGear = $SpinningGear
onready var spinningGear2 = $SpinningGear2
onready var debugTimer = $DebugTimer
onready var gearTimer2 = $GearTimer2
onready var sgf = $SpinningGearFront
onready var sgf2 = $SpinningGearFront2
onready var spinningGearTimer = $SpinningGearTimer
onready var spinningGearTimer2 = $SpinningGearTimer2
onready var plasmaCharge = $PlasmaCharge
onready var plasmaSound = $PlasmaSound



enum {
	MOVE,
	ROLL,
	ATTACK,
	IDLE
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var worldStats = WorldStats

# for sprite control
var laserTop = false
var show = false

var gearOneShow = false
var gearTwoShow = false
var rollingGear = false
# for laser fire rate
var laserboi = true

# only true whilst special attack is active
var zapping = false

# only true while charge attack is active
var chargeAttacking = false

# prevents player from interfering with intro "run up"
var horiZone

# determines charge readiness and velocity for all-direction maneuver
var chargeReady = false
var veLockity = false

# for speed boost / air gordon skill
var zoomOn = false


func _ready():
	
	playerSpriteSpecials.hide()
	aura.hide()
	# randomize()
	spinningGear.hide()
	spinningGear2.hide()

	# Find user's controller type:
	# var pad = Input.get_joy_name(0)
	# print(pad)
	
	# connect signals to appropriate methods
	stats.connect("no_health", self, "queue_free")
	stats.connect("player_paused", self, "stop_moving")
	stats.connect("player_resumed", self, "start_moving")
	stats.connect("give_movement", self, "full_movement")
	stats.connect("green_charged", self, "green_mode")
	stats.connect("red_charged", self, "red_mode")
	stats.connect("purple_charged", self, "purple_mode")
	stats.connect("some_health", self, "heart_monitor")
	
	worldStats.connect("in_the_tall_grass", self, "_stealth_mode")
	worldStats.connect("out_of_the_tall_grass", self, "_visible_again")
	worldStats.connect("bad_trip", self, "bad_trippin")
	stats._ready()
	crosshair.hide()
	playerSpriteHit.hide()
	
	# starting position...need to rethink this if we add player position to saving, and need to stop from doing the initial runup
	# if player_position_saved in save_file is true, load that (upon saving at stations), if its false (default, or any other auto save or world load...maybe in the first intro area of each? )... then:
	print_debug((get_parent().get_parent()).to_string()) #checking for level
	print_debug((get_parent().get_parent()).to_string()[5])
	print_debug(save_file.current_world[5])
	if (save_file.position_saved == true) && (save_file.current_world[5] == (get_parent().get_parent()).to_string()[5]): #checking current world against save file's world for positioning
		global_position.x = save_file.player_position_x
		global_position.y = save_file.player_position_y
		#stats.emit_signal("player_resumed")
		horiZone = true
		veLockity = false
		stats.emit_signal("player_resumed")
		stats.emit_signal("give_movement")
		
		
	else:
		horiZone = false
		global_position.x = -463
		global_position.y = 760
		save_file.position_saved = false
		# send player walking "up" to the first level intro/story zone
		ready_run_state()
		
	
	# activate animation tree and knockback vectors (add vectors to special moves)
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	
	# hide UI elements from popping up on new game
	specialOne.hide()
	playerInventory.hide()
	laserSprite.hide()
	laserTwo.hide()
	laserZone.disabled = true
	blastZone.disabled = true
	
	# send player walking "up" to the first level intro/story zone
	#ready_run_state()
	

func _process(delta):
	if chargeAttacking:
		playerSpriteSpecials.rotation_degrees += 3
		plasmaCharge.show()
		plasmaCharge.rotation_degrees += 9
	else:
		plasmaCharge.hide()
		plasmaCharge.rotation_degrees = 0
		playerSpriteSpecials.rotation_degrees = 0
		
	playerSpriteHit.frame = sprite.frame
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state()
			
		ATTACK:
			attack_state()
			
		IDLE:
			idle_state()
			
	# prevents cancellation of 'ready_run_state'
	if horiZone == false:
		if Input.is_action_just_pressed("ui_up"):
			keep_going()

# func _unhandled_input(event):
	#laser logic for Ray2D
	# if event.is_action_pressed("laser"):
		# print("shotting")
		# laserSprite.show()
		# laserZone.disabled = false
		# var laserSound = LaserSound.instance()
		# get_tree().current_scene.add_child(laserSound)
		# laserTimer.start(0.0)
		# if ray.is_colliding():
			# emit_signal("fired_shot", ray.get_collision_point())

	
func move_state(delta):
	var input_vector = Vector2.ZERO
	
	# horiZone logic
	if horiZone == false:
		input_vector.y = -1
	
	if stats.controlsOn == false:
		input_vector.x = 0
		input_vector.y = 0

	if horiZone == true:
		if stats.controlsOn == true:
			if veLockity == false:
				input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
				input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		

		if input_vector.x == 1:
			laserTop = false
			spinningGear.show()
			spinningGear2.hide()
			sgf.hide()
			sgf2.hide()
			



		elif input_vector.x == -1:
			laserTop = true
			spinningGear.hide()
			spinningGear2.show()
			sgf.hide()
			sgf2.hide()


		elif input_vector.x == 0:
			debugTimer.stop()
			gearTimer2.stop()
			spinningGear.position.y = -13
			spinningGear2.position.y = -13
			spinningGear.position.x = -5
			spinningGear2.position.x = 4
			
			
			if input_vector.y == 1:
				laserTop = true
				spinningGear.hide()
				spinningGear2.hide()
				sgf.show()
				sgf2.show()

			elif input_vector.y == -1:
				laserTop = false
				spinningGear.hide()
				spinningGear2.hide()
				sgf.show()
				sgf2.show()


		
		if Input.is_action_just_pressed("ui_up"):
			show = false
			gearOneShow = false
			gearTwoShow = false
			stats.globalPos = self.global_position
			print_debug(self.global_position)
			spinningGearTimer.start()
			spinningGearTimer2.start()
			
		if Input.is_action_just_released("ui_up"):
			spinningGearTimer.stop()
			spinningGearTimer2.stop()
			sgf.position.y = -13
			sgf2.position.y = -13
				
		if Input.is_action_just_pressed("ui_down"):
			show = true
			gearOneShow = false
			gearTwoShow = false
			stats.globalPos = self.global_position
			spinningGearTimer.start()
			spinningGearTimer2.start()
			
		if Input.is_action_just_released("ui_down"):
			spinningGearTimer.stop()
			spinningGearTimer2.stop()
			sgf.position.y = -13
			sgf2.position.y = -13
				
		if Input.is_action_just_pressed("ui_right"):
			show = false
			gearOneShow = true
			gearTwoShow = false
			stats.globalPos = self.global_position
			debugTimer.start()
			gearTimer2.start()
		
			
		if Input.is_action_just_released("ui_right"):
			debugTimer.stop()
			gearTimer2.stop()
				
		if Input.is_action_just_pressed("ui_left"):
			show = true
			gearOneShow = false
			gearTwoShow = true
			stats.globalPos = self.global_position
			debugTimer.start()
			gearTimer2.start()

			
		if Input.is_action_just_released("ui_left"):
			debugTimer.stop()
			gearTimer2.stop()
		
		if input_vector.x == 0 && input_vector.y == 0:
			if show == false:
				laserTop =false
			elif show == true:
				laserTop = true
			elif gearOneShow:
				spinningGear.show()
				spinningGear2.hide()
			elif gearTwoShow:
				spinningGear.hide()
				spinningGear2.show()
		
		if Input.is_action_just_pressed("roll"):
			
			#adjust so roll only happens on release when zoom is not enabled? tie to zoomTimer
			# right now roll is on pressed for demo, set back to release after demo
			if stats.controlsOn:
				state = ROLL
				crosshair.hide()
				
				rollingGear = true
				$RollTimer.start()
			#commenting out these lines and all release roll code for demo
			#zoomOn = false
#			zoomTimer.start(0.0)
#
#		if Input.is_action_just_released("roll"):
#			if zoomOn == false:
#				state = ROLL
#			zoomTimer.stop()
#			self.MAX_SPEED = 90
#			self.ACCELERATION = 650
	
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
			
			spinningGear.position.x += 1
			spinningGear2.position.x -= 1
			
			#commenting out the following two lines to block charge attack for demo
			chargeTimer.start(0.0)
			chargeReady = false
			
			#commenting out all action released code to block charge attack for demo
		if Input.is_action_just_released("attack"):
			if chargeReady == true:
				playerSpriteSpecials.show()
				spinningGear.hide()
				spinningGear2.hide()
				sprite.hide()
				plasmaSound.play()
				hurtbox.monitoring = false
				aura.show()
				aura.play("default")
				state = ATTACK
				blastZone.disabled = false
				chargeAttacking = true
				veLockity = true
				self.MAX_SPEED = 0
				var sword = animationPlayer.play("SwordSpecial")
				chargeTimer.stop()

			else:
				chargeTimer.stop()
				sprite.show()
				playerSpriteSpecials.hide()
				aura.hide()
				aura.stop()
			
			#laser logic for Ray2D
		if Input.is_action_just_released("laser"):
			crosshair.hide()
			if stats.ammo > 0 && laserboi == true:
				stats.ammo -= 1
				laserboi = false
				if !laserTop:
					laserSprite.show()
				laserSpeed.start()
				laserZone.disabled = false
				worldStats.emit_signal("play_blast_anim")
				var laserSound = LaserSound.instance()
				get_tree().current_scene.add_child(laserSound)
				laserTimer.start(0.0)
				if ray.is_colliding():
					emit_signal("fired_shot", ray.get_collision_point())
				if laserTop:
					laserTwo.show()
			else:
				pass
				
		if Input.is_action_just_pressed("laser"):
			crosshair.show()
			
		if Input.is_action_just_pressed("charge_switch_f"):
			if stats.gcEnabled == true:
				var knifeSound = KnifeSound.instance()
				get_tree().current_scene.add_child(knifeSound)
				if stats.greenCharge == true:
					stats.greenCharge = false
					stats.purpleCharge = true
					stats.emit_signal("purple_charged")
				else:
					stats.greenCharge = true
					stats.purpleCharge = false
					stats.emit_signal("green_charged")
		
		if Input.is_action_just_pressed("special_one"):
			if stats.batteries > 0 && zapping == false && stats.overcharge:
				specialOne.show()
				blastZone.disabled = false
				var electricSound = ElectricSound.instance()
				get_tree().current_scene.add_child(electricSound)
				var special = animationPlayer.play("SpecialOne")
				zapping = true
	
		if Input.is_action_just_pressed("ui_pause"):
			get_tree().paused = true
			stats.emit_signal("enable_pause")
			var pauseSound = PauseSound.instance()
			get_tree().current_scene.add_child(pauseSound)
			playerInventory.show()
			playerInventory.global_position.x = self.position.x - 108
			playerInventory.global_position.y = self.position.y - 35
			button.grab_focus()
			
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		# print(input_vector)
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	hurtbox.monitoring = false
	move()
	
func ready_run_state():
	Input.action_press("ui_up")
	
func keep_going():
	timer.start()
	
	
func full_movement():
	horiZone = true
	
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func idle_state():
	velocity = Vector2.ZERO
	animationState.travel("Idle")
	
func move():
	velocity = move_and_slide(velocity)
	if velocity != Vector2.ZERO:
		rotate_pointer(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.7
	state = MOVE
	hurtbox.monitoring = true
	rollingGear = false
	print_debug(sprite.frame)
	if sprite.frame == 44:
		spinningGear.show()
	elif sprite.frame == 54:
		spinningGear2.show()
	else:
		sgf.show()
		sgf2.show()

func attack_animation_finished():
	state = MOVE
	spinningGear.position.x -= 1
	spinningGear2.position.x += 1
	
	sgf.position.y = -13
	sgf2.position.y = -13

func special_one_finished():
	specialOne.hide()
	stats.batteries -= 1
	zapping = false
	blastZone.disabled = true
	
func stop_moving():
	state = IDLE
	self.MAX_SPEED = 0
	self.ACCELERATION = 0
	self.ROLL_SPEED = 0

func sword_swipe():
	swordSwiper.play()

func gearDown():
	sgf.position.y = -10.5
	sgf2.position.y = -10.5
	
func gearDownest():
	sgf.position.y = -9.0
	sgf2.position.y = -9.0
	
	
func gearUp():
	sgf.position.y = -13
	sgf2.position.y = -13

func roll_sound():
	rollSounds.play()
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()
	
func bad_trippin():
	self.MAX_SPEED = 15
	$TripTimer.start()
	
func sword_special_over():
	blastZone.disabled = true
	chargeAttacking = false
	self.MAX_SPEED = 90
	hurtbox.monitoring = true
	veLockity = false
	playerSpriteSpecials.hide()
	sprite.show()
	aura.hide()
	aura.stop()
	
	
	
func foot_step():
	# for footstep audio
	var foot1 = FootstepOne.instance()
	var foot2 = FootstepTwo.instance()
	var foot3 = FootstepThree.instance()
	var step = random_drop_generator([foot1, foot2, foot3])
	get_tree().current_scene.add_child(step)
	
		
	
func start_moving():
	state = MOVE
	self.MAX_SPEED = 90
	self.ACCELERATION = 650
	self.ROLL_SPEED = 115
	
func rotate_pointer(point_direction: Vector2)->void:
	# to update Ray2D position / angle
	var temp = rad2deg(atan2(point_direction.y, point_direction.x))
	pointer.rotation_degrees = temp
	


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(2)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	sprite.hide()
	playerSpriteHit.show()
	hitSpriteTimer.start()

func _on_Timer_timeout():
	if horiZone == false:
		ready_run_state()

func _on_LaserTimer_timeout():
	laserSprite.hide()
	laserTwo.hide()
	laserZone.disabled = true


func _on_LaserSpeed_timeout():
	laserboi = true
	
func _stealth_mode():
	playerCollision.set_deferred("disabled", true)

	print(self.collision_layer)
	
func _visible_again():
	playerCollision.set_deferred("disabled", false)
	
	print(self.collision_layer)
	
func purple_mode():
	sprite.texture = playerSpritePurple

func green_mode():
	sprite.texture = playerSpriteGreen
	
func red_mode():
	sprite.texture = playerSpriteRed


func _on_TripTimer_timeout():
	self.MAX_SPEED = 90


func _on_ChargeTimer_timeout():
	chargeReady = true




func _on_ZoomTimer_timeout():
	zoomOn = true
	
	self.MAX_SPEED = 165
	self.ACCELERATION = 735
	zoomOffTimer.start()
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if  (input_vector.x != 0) || (input_vector.y != 0):
		zoomSound.play()
		var zoomCloud = ZoomCloud.instance()
		get_tree().current_scene.add_child(zoomCloud)
		zoomCloud.global_position.x = self.global_position.x
		zoomCloud.global_position.y = self.global_position.y + 3
	


func _on_ZoomOffTimer_timeout():
	zoomTimer.stop()
	self.MAX_SPEED = 90
	self.ACCELERATION = 650


func _on_HitSpriteTimer_timeout():
	sprite.show()
	playerSpriteHit.hide()
	

func heart_monitor():
	if stats.health == 1:
		heartbeat.play(0.0)
		heartBeatTimer.start()
	else:
		heartbeat.stop()
		heartBeatTimer.stop()


func _on_HeartBeat_finished():
	if stats.health == 1:
		heartbeat.play(0.0)


func _on_HeartBeatTimer_timeout():
	sprite.hide()
	playerSpriteHit.show()
	hitSpriteTimer.start()


func _on_DebugTimer_timeout():
	spinningGear.position.y -= .5
	spinningGear2.position.y -= .5
	gearTimer2.start()


func _on_GearTimer2_timeout():
	spinningGear.position.y += .5
	spinningGear2.position.y += .5
	debugTimer.start()





func _on_RollTimer_timeout():
	spinningGear.hide()
	spinningGear2.hide()
	sgf.hide()
	sgf2.hide()


func _on_SpinningGearTimer_timeout():
	#print_debug("rockin")
	sgf.position.y -= .5
	sgf2.position.y -= .5
	spinningGearTimer2.start()


func _on_SpinningGearTimer2_timeout():
	sgf.position.y += .5
	sgf2.position.y += .5
	spinningGearTimer.start()
