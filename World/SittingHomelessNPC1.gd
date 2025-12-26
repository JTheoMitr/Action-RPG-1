extends StaticBody2D

onready var npc_prompt = $NPCInteractPrompt
onready var byeTimer = $ByeTimer
var stats = PlayerStats

var inArea := false

func _ready():
	npc_prompt.hide()

func _process(_delta):
	if inArea and Input.is_action_just_pressed("roll"):
		npc_prompt.set_text("[center]Thank you!")
		stats.emit_signal("player_paused")
		byeTimer.start()

func _on_Area2D_area_entered(_area):
	inArea = true
	npc_prompt.set_text("[center]Pay $$")
	npc_prompt.show()

func _on_Area2D_area_exited(_area):
	inArea = false
	npc_prompt.hide()

func _on_ByeTimer_timeout():
	stats.emit_signal("player_resumed")
	npc_prompt.hide()
