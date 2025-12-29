extends Button

export(String) var title_text = "" setget set_title

export(float) var scroll_speed = 35.0
export(float) var pause_seconds = 0.6

onready var clip = $Clip
onready var title = $Clip/Title

var _active = false
var _dir = -1.0
var _pause = 0.0
var _start_x = 0.0
var _min_x = 0.0


func _ready():
	focus_mode = Control.FOCUS_ALL
	clip.rect_clip_content = true

	_start_x = title.rect_position.x

	# Apply exported value once the node is ready
	set_title(title_text)

	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")


func set_title(t):
	title_text = str(t)
	if not is_inside_tree():
		return

	title.text = title_text

	# Wait one frame so size updates before measuring
	yield(get_tree(), "idle_frame")

	_recalc_limits()
	_reset()



func _recalc_limits():
	var text_w = _get_label_text_width(title)
	var view_w = clip.rect_size.x

	# If it fits, don't scroll
	if text_w <= view_w:
		_min_x = _start_x
	else:
		_min_x = _start_x - (text_w - view_w)


func _get_label_text_width(lbl):
	# Use the label's font to measure actual pixel width (reliable in 3.5)
	var font = lbl.get_font("font")
	if font == null:
		# Fallback: approximate if no font found
		return lbl.text.length() * 8

	return font.get_string_size(lbl.text).x


func _on_focus_entered():
	_recalc_limits()
	if _min_x != _start_x:
		_active = true
		_dir = -1.0
		_pause = pause_seconds


func _on_focus_exited():
	_active = false
	_reset()


func _reset():
	title.rect_position.x = _start_x


func _process(delta):
	if not _active:
		return

	if _pause > 0.0:
		_pause -= delta
		return

	title.rect_position.x += _dir * scroll_speed * delta

	if title.rect_position.x <= _min_x:
		title.rect_position.x = _min_x
		_dir = 1.0
		_pause = pause_seconds
	elif title.rect_position.x >= _start_x:
		title.rect_position.x = _start_x
		_dir = -1.0
		_pause = pause_seconds
