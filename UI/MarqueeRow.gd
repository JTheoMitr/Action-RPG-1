extends Button

export(String) var title_text = "" setget set_title

export(Color) var normal_color = Color(0, 0, 0)   # black
export(Color) var focus_color  = Color(1, 1, 1)   # white

export(float) var scroll_speed = 35.0
export(float) var pause_seconds = 0.6

# NEW: optional gate + tighter bounds
export(int) var min_chars_to_scroll = 0        # 0 = disable char gate
export(int) var end_padding_px = 6             # prevents scrolling into "empty" too far

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
	var view_w = clip.rect_size.x
	var text_w = _get_label_text_width(title)

	# Optional: minimum character threshold (helps avoid scrolling short names even if narrow viewport)
	if min_chars_to_scroll > 0 and title.text.length() < min_chars_to_scroll:
		_min_x = _start_x
		return

	# If it fits, don't scroll
	if text_w <= view_w:
		_min_x = _start_x
		return

	# Max left travel so the end of the text JUST reaches the right edge of the viewport
	# end_padding_px keeps a tiny gap so it doesn't feel like it overshoots into empty space
	_min_x = _start_x - (text_w - view_w) - end_padding_px

	# Safety: never allow min_x to be to the right of start
	if _min_x > _start_x:
		_min_x = _start_x


func _get_label_text_width(lbl):
	var font = lbl.get_font("font")
	if font == null:
		return lbl.text.length() * 8
	return font.get_string_size(lbl.text).x


func _on_focus_entered():
	# Important: reset position so width math always starts from the same place
	_reset()

	_recalc_limits()
	_set_label_color(focus_color)

	# Only activate marquee when there's actual travel distance
	if _min_x < _start_x:
		_active = true
		_dir = -1.0
		_pause = pause_seconds
	else:
		_active = false


func _on_focus_exited():
	_active = false
	_set_label_color(normal_color)
	_reset()


func _set_label_color(c: Color) -> void:
	title.add_color_override("font_color", c)


func _reset():
	title.rect_position.x = _start_x


func _process(delta):
	if not _active:
		return

	if _pause > 0.0:
		_pause -= delta
		return

	title.rect_position.x += _dir * scroll_speed * delta

	# NEW: hard clamp so it can NEVER overshoot into blank space
	title.rect_position.x = clamp(title.rect_position.x, _min_x, _start_x)

	# Pause & reverse at endpoints
	if is_equal_approx(title.rect_position.x, _min_x):
		_dir = 1.0
		_pause = pause_seconds
	elif is_equal_approx(title.rect_position.x, _start_x):
		_dir = -1.0
		_pause = pause_seconds
