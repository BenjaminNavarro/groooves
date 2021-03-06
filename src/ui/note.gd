extends ColorRect
class_name NoteUI

var snap := false
var note_velocity := 100
var skip_notification := true
var selected := false

onready var _tracks := get_parent().get_parent()


func _ready():
	rect_global_position.y = get_parent().rect_global_position.y + (get_parent().rect_size.y - rect_size.y) / 2


func set_note_position(pos: float):
	rect_position.x = pos
	_snap_if()
	_signal_modification()


func set_note_global_position(pos: float):
	rect_global_position.x = pos
	_snap_if()
	_signal_modification()


func get_note_relative_position() -> float:
	return rect_position.x / _tracks.get_beat_width()


func set_note_relative_position(pos: float):
	rect_position.x  = pos * _tracks.get_beat_width()
	_signal_modification()


func get_track_name() -> String:
	return get_parent().name


func get_note_velocity() -> int:
	return note_velocity


func _process(_delta: float):
	if selected:
		rect_global_position.x = clamp(
			get_global_mouse_position().x,
			get_parent().rect_global_position.x,
			get_parent().rect_global_position.x + get_parent().rect_size.x)
		_snap_if()


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			selected = mouse_event.pressed
			if not selected:
				_signal_modification()


func _snap_if():
	if snap:
		var closest := 1000000.0
		var new_position := rect_position.x
		for snap_loc in _tracks.snap_locations:
			var dist := abs(rect_position.x - snap_loc)
			if dist < closest:
				new_position = snap_loc
				closest = dist
		rect_position.x = new_position


func _on_snap_changed(state: bool):
	snap = state


func _signal_modification():
	if not skip_notification:
		_tracks.editor.emit_signal("groove_changed")
