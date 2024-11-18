extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popupText = $PopupDialog/RichTextLabel
onready var popup = $PopupDialog
onready var stats = PlayerStats
onready var grunt = $Grunt
onready var save_data = SaveFile.g_data

var dialogTextNum
var dialogText
var popped
var controlsOn
# Called when the node enters the scene tree for the first time.
func _ready():
	if save_data.world_one_boss_lives == false:
		queue_free()
	dialogTextNum = 0
	popped = false
	controlsOn = false
	dialogText = "[center] Wouldn't go that way if I were you...'Big Drill' Larry is on a real tear today"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if popped == false:
		popup.rect_global_position.y = global_position.y + 35
		popup.rect_global_position.x = global_position.x + 20
		popupText.bbcode_text = dialogText
	if Input.is_action_just_pressed("interact") && controlsOn:
		dialogTextNum += 1
	if popped == false:
		match dialogTextNum:
			0:
				dialogText = "[center]Wouldn't go that way if I were you...'Big Drill' Larry is on a real tear today"
			1:
				dialogText = "[center]OILCO picked the wrong spot for his drill site; there's no oil here..."
			2:
				dialogText = "[center]I swear those jerks at HQ do no research before sending us out here"
			3:
				dialogText = "[center]What's that? Well, if you insist on taking him on..."
			4:
				dialogText = "[center]You should pay a visit to 'Chill Willy's Pop Shop'"
			5:
				dialogText = "[center]He'll have some items for sale that will give you the edge you need"
			6:
				dialogText = "[center]Last time I saw his food truck... it was due East from here"
			7:
				dialogText = "[center]Just dont tell the big boss, he'd drill me silly"
			8:
				dialogText = "[center]Anyways, time for my lunch break. \n Have you seen Kyle?"
			9:
				dialogText = "[center]He'd be in a uniform similar to mine. He's usually patrolling the gate..."
			10:
				dialogText = "[center]We're supposed to get kebabs. I'll go find him..."
			11:
				popup.queue_free()
				popped = true
				grunt.play()
				controlsOn = false
				stats.emit_signal("player_resumed")

func _on_Area2D_area_entered(area):
	controlsOn = true
	if popped == false:
		grunt.play()
		popup.popup()
		stats.emit_signal("player_paused")
