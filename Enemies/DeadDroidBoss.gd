extends StaticBody2D

onready var timer = $Timer
onready var sprite = $DeadBotSprite
onready var destructTimer = $DestructTimer
onready var popupD = $PopupDestruct
onready var explosionAnim = $AnimatedSprite
onready var destructMsg = $PopupDestruct/RichTextLabel
onready var dust1 = $DustAnimation
onready var dust2 = $DustAnimation2
onready var dust3 = $DustAnimation3
onready var dust4 = $DustAnimation4




# Called when the node enters the scene tree for the first time.

func _process(delta):
	popupD.rect_global_position = self.global_position
	explosionAnim.global_position.x = self.global_position.x + 41
	explosionAnim.global_position.y = self.global_position.y
	popupD.rect_global_position.x = self.global_position.x
	popupD.rect_global_position.y = self.global_position.y - 55
	destructMsg.text = "Self Destruct in: " + str(destructTimer.time_left).split(".")[0]

func _ready():
	self.hide()
	timer.start()
	explosionAnim.hide()
	explosionAnim.frame = 71


func _on_Timer_timeout():
	self.show()
	popupD.show()
	destructTimer.start()
	


func _on_DestructTimer_timeout():
	explosionAnim.show()
	dust1.hide()
	dust2.hide()
	dust3.hide()
	dust4.hide()
	popupD.hide()
	sprite.hide()
	explosionAnim.frame = 0
	explosionAnim.play("explode")


func _on_AnimatedSprite_animation_finished():
	self.call_deferred("queue_free")
