extends Control

var xp = 3 setget set_xp
var max_xp = 3 setget set_max_experience


func set_xp(value):
	xp = clamp(value, 0, max_xp)
	$RichTextLabel.text = "x " + str(self.xp)
	
func set_max_experience(value):
	max_xp = max(value, 1)
	self.xp = min(xp, max_xp)
	
func _ready():
	self.max_xp = PlayerStats.max_xp
	self.xp = PlayerStats.xp
	PlayerStats.connect("xp_changed", self, "set_xp")
	PlayerStats.connect("max_xp_changed", self, "set_max_experience")
