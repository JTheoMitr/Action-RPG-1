extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const ElectricSound = preload("res://Music and Sounds/SpecialOneSound.tscn")
const FootstepOne = preload("res://Music and Sounds/Footstep1.tscn")
const FootstepTwo = preload("res://Music and Sounds/Footstep2.tscn")
const FootstepThree = preload("res://Music and Sounds/Footstep3.tscn")
const PauseSound = preload("res://Music and Sounds/PauseSound.tscn")
const LaserSound = preload("res://Music and Sounds/LaserSound.tscn")


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
onready var button = $PlayerInventory/Control/CenterContainer/HBoxContainer/VBoxContainer/Button
onready var pointer = $Pointer
onready var ray = $Pointer/RayCast2D
onready var laserSprite = $Pointer/Sprite
onready var laserTwo = $Pointer/Sprite2
onready var laserTimer = $Pointer/LaserTimer
onready var laserSpeed = $Pointer/LaserSpeed
onready var laserZone = $Pointer/Sprite/LaserZone/CollisionShape2D

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

# for laser fire rate
var laserboi = true

# only true whilst special attack is active
var zapping = false

# prevents player from interfering with intro "run up"
var horiZone = false


func _ready():
	# randomize()
	
	# Find user's controller type:
	# var pad = Input.get_joy_name(0)
	# print(pad)
	
	# connect signals to appropriate methods
	stats.connect("no_health", self, "queue_free")
	stats.connect("player_paused", self, "stop_moving")
	stats.connect("player_resumed", self, "start_moving")
	stats.connect("give_movement", self, "full_movement")
	worldStats.connect("in_the_tall_grass", self, "_stealth_mode")
	worldStats.connect("out_of_the_tall_grass", self, "_visible_again")
	stats._ready()
	
	# starting position
	global_position.x = -463
	global_position.y = 760
	
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
	ready_run_state()
	

func _process(delta):
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

	if horiZone == true:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		if Input.is_action_just_pressed("ui_up"):
			laserTop = false
			
		if Input.is_action_just_pressed("ui_down"):
			laserTop = true
		
		if Input.is_action_just_pressed("roll"):
			state = ROLL
	
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
			
			#laser logic for Ray2D
		if Input.is_action_just_pressed("laser"):
			if stats.ammo > 0 && laserboi == true:
				stats.ammo -= 1
				laserSprite.show()
				laserboi = false
				laserSpeed.start()
				laserZone.disabled = false
				var laserSound = LaserSound.instance()
				get_tree().current_scene.add_child(laserSound)
				laserTimer.start(0.0)
				if ray.is_colliding():
					emit_signal("fired_shot", ray.get_collision_point())
				if laserTop == true:
					laserTwo.show()
			else:
				pass
			
		
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

func attack_animation_finished():
	state = MOVE

func special_one_finished():
	specialOne.hide()
	stats.batteries -= 1
	zapping = false
	
func stop_moving():
	state = IDLE
	self.MAX_SPEED = 0
	self.ACCELERATION = 0
	self.ROLL_SPEED = 0

func sword_swipe():
	swordSwiper.play()
	
func roll_sound():
	rollSounds.play()
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()
	
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
