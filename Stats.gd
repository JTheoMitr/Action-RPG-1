extends Node

export(int) var max_health = 1 setget set_max_health
export(int) var max_boss_keys = 1 setget set_max_boss_keys
export(int) var max_keys = 3 setget set_max_keys
export(int) var max_keys_collected = 4 setget set_max_keys_collected
export(int) var max_batteries = 3 setget set_max_batteries
export(int) var max_coins = 99 setget set_max_coins
export(int) var max_xp = 999999999 setget set_max_experience
export(int) var max_level = 999 setget set_max_level
export(int) var max_redpops = 10 setget set_max_redpops
export(int) var max_bluepops = 10 setget set_max_bluepops

export(int) var max_ammo = 99 setget set_max_ammo


var keys = max_keys setget set_keys
var boss_keys = max_boss_keys setget set_boss_keys
var keys_collected = max_keys_collected setget set_keys_collected
var health = max_health setget set_health
var batteries = max_batteries setget set_batteries
var coins = max_coins setget set_coins
var xp = max_xp setget set_xp
var level = max_level setget set_level
var redpops = max_redpops setget set_redpops
var bluepops = max_bluepops setget set_bluepops
var ammo = max_ammo setget set_ammo

var overcharge = false
# controls player's ability to use special one

var keyLost = false
#determines text in the key alert - key gained or key lost

var c4Acquired = false
#determines whether or not the player has c4 equipped

var xpCap = 50
#starting point for leveling up

var purpleCharge = true
#deflect ability on purple projectiles

var greenCharge = false
var gcEnabled = false
#deflect ability on green projectiles

var redCharge = false
var rcEnabled = false
#deflect ability on red projectiles

#need to pick a button to toggle charges

# add sundaes

onready var save_file = SaveFile.g_data

signal no_health
signal no_keys
signal no_batteries
signal no_coins
signal no_redpops
signal no_bluepops
signal no_ammo

signal player_paused
signal player_resumed
signal give_movement
signal boss_key_acquired

signal green_charged
signal red_charged
signal purple_charged

signal health_changed(value)
signal max_health_changed(value)
signal keys_changed(value)
signal max_keys_changed(value)
signal batteries_changed(value)
signal max_batteries_changed(value)
signal coins_changed(value)
signal max_coins_changed(value)
signal xp_changed(value)
signal max_xp_changed(value)
signal level_changed(value)
signal max_level_changed(value)
signal redpops_changed(value)
signal max_redpops_changed(value)
signal bluepops_changed(value)
signal max_bluepops_changed(value)
signal ammo_changed(value)
signal max_ammo_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_max_experience(value):
	max_xp = value
	self.xp = min(xp, max_xp)
	emit_signal("max_xp_changed", max_xp)
	
func set_max_level(value):
	max_level = value
	self.level = min(level, max_level)
	emit_signal("max_level_changed", max_level)
	
	
	
func set_max_keys(value):
	max_keys = value
	self.keys = min(keys, max_keys)
	emit_signal("max_keys_changed", max_keys)
	
func set_max_keys_collected(value):
	max_keys_collected = value
	self.keys_collected = min(keys_collected, max_keys_collected)
	
func set_max_boss_keys(value):
	max_boss_keys = value
	self.boss_keys = min(boss_keys, max_boss_keys)
	
func set_max_batteries(value):
	max_batteries = value
	self.batteries = min(batteries, max_batteries)
	emit_signal("max_batteries_changed", max_batteries)
	
func set_max_ammo(value):
	max_ammo = value
	self.ammo = min(ammo, max_ammo)
	emit_signal("max_ammo_changed", max_ammo)
	
func set_max_coins(value):
	max_coins = value
	self.coins = min(coins, max_coins)
	emit_signal("max_coins_changed", max_coins)
	
func set_max_redpops(value):
	max_redpops = value
	self.redpops = min(redpops, max_redpops)
	emit_signal("max_redpops_changed", max_redpops)

func set_max_bluepops(value):
	max_bluepops = value
	self.bluepops = min(bluepops, max_bluepops)
	emit_signal("max_bluepops_changed", max_bluepops)


func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func set_keys(value):
	keys = value
	save_file.player_keys = value
	emit_signal("keys_changed")
	if keys == 0:
		emit_signal("no_keys")
		
func set_keys_collected(value):
	keys_collected = value
	save_file.player_keys_collected = value
			
func set_xp(value):
	xp = value
	save_file.player_xp = value
	#print_debug(value)
	#print_debug(save_file.player_xp)
	emit_signal("xp_changed", xp)
	if xp >= xpCap:
		# print_debug("levelsup")
		# print_debug(xp)
		# print_debug(xpCap)
		self.level += 1
		#save_file.player_level += 1
		xp = (xp - xpCap)
		#save_file.player_xp = (xp - xpCap)
		var holdCap = (xpCap * 2)
		xpCap = holdCap
		save_file.player_xpCap = holdCap
		# update attributes here?
		# auto-save here?
		

func set_level(value):
	level = value
	save_file.player_level = value
	emit_signal("level_changed")
	
func set_boss_keys(value):
	boss_keys = value
	save_file.player_boss_keys = value
		
func set_batteries(value):
	batteries = value
	save_file.player_batteries = value	
	emit_signal("batteries_changed", batteries)
	if batteries == 0:
		emit_signal("no_batteries")
		
func set_ammo(value):
	ammo = value
	save_file.player_ammo = value
	emit_signal("ammo_changed", ammo)
	if ammo == 0:
		emit_signal("no_ammo")
		
func set_coins(value):
	coins = value
	save_file.player_coins = value
	emit_signal("coins_changed", coins)
	if coins == 0:
		emit_signal("no_coins")
		
func set_redpops(value):
	redpops = value
	save_file.player_red_pops = value
	emit_signal("redpops_changed", redpops)
	if redpops == 0:
		emit_signal("no_redpops")

func set_bluepops(value):
	bluepops = value
	save_file.player_blue_pops = value
	emit_signal("bluepops_changed", bluepops)
	if bluepops == 0:
		emit_signal("no_bluepops")


func _ready():
	#print_debug(save_file)
	self.health = max_health
	self.max_health = save_file.player_max_health
	#self.keys = 0
	self.keys = save_file.player_keys
	#self.keys_collected = 0
	self.keys_collected = save_file.player_keys_collected
	#self.batteries = 2
	self.batteries = save_file.player_batteries
	#self.coins = 0
	self.coins = save_file.player_coins
	#self.xp = 0
	self.xp = save_file.player_xp
	#self.redpops = 0
	self.redpops = save_file.player_red_pops
	#self.bluepops = 0
	self.bluepops = save_file.player_blue_pops
	#self.boss_keys = 0
	self.boss_keys = save_file.player_boss_keys
	#self.ammo = 10
	self.ammo = save_file.player_ammo
	#self.level = 1
	self.level = save_file.player_level
	#self.xpCap = 50
	self.xpCap = save_file.player_xpCap
	#self.overcharge = false
	self.overcharge = save_file.overcharge_status
	
func reset():
	#print_debug(save_file)
	self.health = max_health
	self.max_health = save_file.player_max_health
	#self.keys = 0
	self.keys = save_file.player_keys
	#self.keys_collected = 0
	self.keys_collected = save_file.player_keys_collected
	#self.batteries = 2
	self.batteries = save_file.player_batteries
	#self.coins = 0
	self.coins = save_file.player_coins
	#self.xp = 0
	self.xp = save_file.player_xp
	#self.redpops = 0
	self.xp = save_file.player_red_pops
	#self.bluepops = 0
	self.bluepops = save_file.player_blue_pops
	#self.boss_keys = 0
	self.boss_keys = save_file.player_boss_keys
	#self.ammo = 10
	self.ammo = save_file.player_ammo
	#self.level = 1
	self.level = save_file.player_level
	#self.xpCap = 50
	self.xpCap = save_file.player_xpCap
	#self.overcharge = false
	self.overcharge = save_file.overcharge_status



