extends StaticBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var purr = $PurrStreamPlayer
onready var chime = $ChimeStreamPlayer
onready var popup = $SaveCatDialogue
onready var yesButton = $SaveCatDialogue/HBoxContainer/YesButton
onready var noButton = $SaveCatDialogue/HBoxContainer/NoButton
onready var text = $SaveCatDialogue/RichTextLabel
onready var timer = $Timer
onready var cont = $SaveCatDialogue/Continue
onready var btnsprite = $SaveCatDialogue/HBoxContainer/ButtonSprite

var saved = false

var stats = PlayerStats
var worldStats = WorldStats

# Called when the node enters the scene tree for the first time.
func _ready():
	text.bbcode_enabled = true
	cont.hide()
	btnsprite.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position = self.position
	if saved:
		if (Input.is_action_pressed("interact")):
			popup.show()
			text.bbcode_text = "[center] \nSaveCat now slumbers elsewhere [/center]"
			stats.emit_signal("player_resumed")
			cont.hide()
			btnsprite.hide()
			timer.start()

func _on_ChimeTriggerArea2D_area_entered(area):
	chime.play()
	# worldStats.emit_signal("fade_music_out")

func _on_PurrTriggerArea2D_area_entered(area):
	purr.play()
	# worldStats.emit_signal("lowest_volume")
	
	# print("Cat position is:")
	# print(self.position)

func _on_ChimeTriggerArea2D_area_exited(area):
	chime.stop()
	purr.stop()
	# worldStats.emit_signal("fade_music_in")

func _on_PurrTriggerArea2D_area_exited(area):
	purr.stop()
	
func _on_YesButton_pressed():
	saved = true
	yesButton.queue_free()
	noButton.queue_free()
	cont.show()
	btnsprite.show()
	text.bbcode_text = "[center] \nYour game has been saved. [/center]"

func _on_Timer_timeout():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_BellyRubArea_area_entered(area):
	popup.popup()
	yesButton.grab_focus()
	stats.emit_signal("player_paused")
