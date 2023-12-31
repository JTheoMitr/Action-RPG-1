extends Control

var ammo = 3 setget set_ammo
var max_ammo = 3 setget set_max_ammo


func set_ammo(value):
	ammo = clamp(value, 0, max_ammo)
	$RichTextLabel.text = str(self.ammo)
	
func set_max_ammo(value):
	max_ammo = max(value, 1)
	self.ammo = min(ammo, max_ammo)
	
func _ready():
	self.max_ammo = PlayerStats.max_ammo
	self.ammo = PlayerStats.ammo
	PlayerStats.connect("ammo_changed", self, "set_ammo")
	PlayerStats.connect("max_ammo_changed", self, "set_max_ammo")
	
	
