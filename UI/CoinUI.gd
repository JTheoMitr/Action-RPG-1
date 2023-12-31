extends Control

var coins = 3 setget set_coins
var max_coins = 3 setget set_max_coins


func set_coins(value):
	coins = clamp(value, 0, max_coins)
	$RichTextLabel.text = "x " + str(self.coins)
	
func set_max_coins(value):
	max_coins = max(value, 1)
	self.coins = min(coins, max_coins)
	
func _ready():
	self.max_coins = PlayerStats.max_coins
	self.coins = PlayerStats.coins
	PlayerStats.connect("coins_changed", self, "set_coins")
	PlayerStats.connect("max_coins_changed", self, "set_max_coins")
