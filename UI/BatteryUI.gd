extends Control


var batts = 3 setget set_batts
var max_batts = 3 setget set_max_batts

var stats = PlayerStats

onready var battUIFull = $BattUIFull
onready var battUIEmpty = $BattUIEmpty

func _process(delta):
	if stats.overcharge == false:
		self.hide()
	else:
		self.show()
			

func set_batts(value):
	batts = clamp(value, 0, max_batts)
	if battUIFull != null:
		battUIFull.rect_size.x = batts * 32


func set_max_batts(value):
	max_batts = max(value, 1)
	self.batts = min(batts, max_batts)
	if battUIEmpty != null:
		battUIEmpty.rect_size.x = max_batts * 40

func _ready():
#	self.hide()
	self.max_batts = PlayerStats.max_batteries
	self.batts = PlayerStats.batteries
	PlayerStats.connect("batteries_changed", self, "set_batts")
	PlayerStats.connect("max_batteries_changed", self, "set_max_batts")
