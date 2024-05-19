extends Node

export(int) var max_freed = 1 setget set_max_freed

var freed = max_freed setget set_freed

signal fade_music_in
signal fade_music_out
signal lowest_volume
signal open_fence
signal open_fence_two
signal in_the_tall_grass
signal out_of_the_tall_grass
signal play_blast_anim
signal rage_mode

func set_max_freed(value):
	max_freed = value
	self.freed = min(freed, max_freed)
	
func set_freed(value):
	freed = value

func _ready():
	self.freed = 0
