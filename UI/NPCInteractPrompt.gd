extends Node2D

onready var label: RichTextLabel = $Sprite/RichTextLabel

export var default_text := "[center]Interact"

func _ready():
	hide()
	set_text(default_text)

func set_text(t: String) -> void:
	label.bbcode_text = t
