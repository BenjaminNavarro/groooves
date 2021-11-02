extends Control
class_name GrooveTracksUI

export(NodePath) var audio_track
export(Color) var playhead_color: Color
export(float) var playhead_width := 1.0
export(Color) var line_color: Color
export(float) var line_width := 1.0
export(Color) var sub_line_color: Color
export(float) var sub_line_width := 1.0

var snap_locations := Array()

onready var editor := get_parent().get_parent()

var _dirty := false
var _audio_track: Track

func _ready():
	_audio_track = get_node(audio_track)
	# warning-ignore:return_value_discarded
	editor.connect("div_per_beat_changed", self, "set_dirty")
	# warning-ignore:return_value_discarded
	editor.connect("length_changed", self, "set_dirty")


func _process(_delta):
	if _dirty or _audio_track.state == Track.State.Playing:
		update()
		_dirty = false


func _draw():
	var divs = editor.length * editor.div_per_beat
	_draw_grid(divs, editor.div_per_beat)
	_draw_playhead()


func add_note(event: Track.Event):
	var track_name: String = Track.Note.keys()[event.note]
	get_node(track_name).add_note(event)


func _draw_grid(divs: int, div_per_beat: int):
	snap_locations.clear()
	for i in range(divs):
		var x_pos = i * (rect_size.x / divs)
		var y_start = 0
		var y_end = rect_size.y
		var from := Vector2(x_pos, y_start)
		var to := Vector2(x_pos, y_end)
		if i % div_per_beat == 0:
			draw_line(from, to, line_color, line_width)
		else:
			draw_line(from, to, sub_line_color, sub_line_width)
		snap_locations.push_back(x_pos)


func _draw_playhead():
	var beat_size: float = rect_size.x / editor.length
	var x_pos := beat_size * _audio_track.current_position
	var y_start = 0
	var y_end = rect_size.y
	var from := Vector2(x_pos, y_start)
	var to := Vector2(x_pos, y_end)
	draw_line(from, to, playhead_color, playhead_width)


func set_dirty(_dummy):
	_dirty = true


func get_beat_width() -> float:
	return rect_size.x / editor.length

