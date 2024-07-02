extends Node

export(int) var max_freed = 1 setget set_max_freed

var freed = max_freed setget set_freed

onready var save_file = SaveFile.g_data

signal fade_music_in
signal fade_music_out
signal lowest_volume
signal open_fence
signal open_fence_two
signal open_fence_three
signal in_the_tall_grass
signal out_of_the_tall_grass
signal play_blast_anim
signal rage_mode
signal portal_opened
signal portal_2_opened
signal chamber_one_start

func set_max_freed(value):
	max_freed = value
	self.freed = min(freed, max_freed)
	
func set_freed(value):
	freed = value
	if save_file != null:
		save_file.worldstats_freed = value
	

func _ready():
	#self.freed = 0
	self.freed = save_file.worldstats_freed
	print_debug(self.freed)
