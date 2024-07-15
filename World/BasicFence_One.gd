extends AnimatedSprite

var worldStats = WorldStats
onready var save_file = SaveFile.g_data
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var collisionShape = $StaticBody2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if save_file.gate_1_opened == true:
		self.frame = 1
		collisionShape.queue_free()
	else:
		self.frame = 0
		worldStats.connect("open_fence", self, "open_sesame")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func open_sesame():
		self.frame = 1
		collisionShape.queue_free()
		save_file.gate_1_opened = true
		
