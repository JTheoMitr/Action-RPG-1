extends Node

const SAVE_FILE = "user://save_file.save"

var g_data = {"player_level": 1,
			"player_xp": 0,
			"player_xpCap": 50,
			"player_max_health": 4,
			"player_health": 4,
			"player_coins": 0,
			"player_batteries": 2,
			"player_ammo": 10,
			"player_keys": 0,
			"player_keys_collected": 0,
			"player_boss_keys": 0,
			"player_red_pops": 0,
			"player_blue_pops": 0,
			"worldstats_freed": 0,
			"overcharge_status": false,
			"world_one_boss_lives": true,
			"world_two_boss_lives": true,
			}

func _ready():
	print_debug("save file ready")
	#var dir = Directory.new()
	#dir.remove(SAVE_FILE)
	load_data()

func save_data():
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(g_data)
	file.close()

func load_data():
	var file = File.new()
	print_debug(file.file_exists(SAVE_FILE))
	if not file.file_exists(SAVE_FILE):
		g_data = {
			"player_level": 1,
			"player_xp": 0,
			"player_xpCap": 50,
			"player_max_health": 4,
			"player_health": 4,
			"player_coins": 0,
			"player_batteries": 2,
			"player_ammo": 10,
			"player_keys": 0,
			"player_keys_collected": 0,
			"player_boss_keys": 0,
			"player_red_pops": 0,
			"player_blue_pops": 0,
			"worldstats_freed": 0,
			"overcharge_status": false,
			"world_one_boss_lives": true,
			"world_two_boss_lives": true,
		}
		save_data()
	file.open(SAVE_FILE, File.READ)
	g_data = file.get_var()
	file.close()
	
func clear_save_file():
	var dir = Directory.new()
	dir.remove(SAVE_FILE)
	load_data()
