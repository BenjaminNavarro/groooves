extends Control
class_name GrooveTracksUI

export(Color) var line_color: Color
export(float) var line_width := 1.0
export(Color) var sub_line_color: Color
export(float) var sub_line_width := 1.0

var snap_locations := Array()

onready var _editor := get_parent().get_parent()

var _dirty := false

func _ready():
	# warning-ignore:return_value_discarded
	_editor.connect("div_per_beat_changed", self, "set_dirty")
	# warning-ignore:return_value_discarded
	_editor.connect("length_changed", self, "set_dirty")


func _process(_delta):
	if _dirty:
		print("calling update")
		update()
		_dirty = false

func _draw():
	var beats = _editor.length * _editor.div_per_beat
	_draw_grid(beats, _editor.div_per_beat)


func _draw_grid(beats: int, div_per_beat: int):
	snap_locations.clear()
	for i in range(beats):
		var x_pos = i * (rect_size.x / beats)
		var y_start = 0
		var y_end = rect_size.y
		var from := Vector2(x_pos, y_start)
		var to := Vector2(x_pos, y_end)
		if i % div_per_beat == 0:
			draw_line(from, to, line_color, line_width)
		else:
			draw_line(from, to, sub_line_color, sub_line_width)
		snap_locations.push_back(x_pos)

func set_dirty(_dummy):
	_dirty = true
