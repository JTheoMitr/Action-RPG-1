extends Area2D

onready var popup = $IntroDialog1
onready var text = $IntroDialog1/RichTextLabel
onready var sprite = $IntroDialog1/Sprite
onready var stats = PlayerStats

onready var labSprite = preload("res://Enemies/LabNPCOneHeadshot.png")
onready var proSprite = preload("res://Dialogue Headshots/main_player_face_still.png")

var inArea = false
var textNum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	textNum = 0
	inArea = false
	
func _process(delta):
	popup.rect_global_position.x = self.position.x - 75
	popup.rect_global_position.y = self.position.y - 15
	
	if (inArea == true) && Input.is_action_just_pressed("interact"):
		textNum += 1
		if textNum == 1:
			text.bbcode_text = "[center]\n Cloning Droid Soldiers here in the caverns[/center]"
			#sprite.texture = proSprite
			#sprite.scale.x = 2.5
			#sprite.scale.y = 2.5
			#sprite.global_position.y += 12
		elif textNum == 2:
			text.bbcode_text = "[center]\n Hey guy, you shouldn't be down here.[center]"
			sprite.texture = labSprite
			sprite.scale.x = 2.5
			sprite.scale.y = 2.5
			sprite.global_position.y -= 12
		elif textNum == 3:
			stats.emit_signal("player_resumed")
			stats.emit_signal("give_movement")
			Input.action_press("ui_up")
			Input.action_release("ui_up")
			popup.hide()
			queue_free()


func _on_IntroArea_area_entered(area):
	popup.popup()
	inArea = true
	stats.emit_signal("player_paused")
	

