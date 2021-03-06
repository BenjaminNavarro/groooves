extends Control
class_name GrooveTrackUI


var _note_scene := preload("res://ui/note.tscn")
var _last_added_note: NoteUI

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			if mouse_event.pressed:
				_last_added_note = _create_note()
				_last_added_note.set_note_global_position(get_global_mouse_position().x)
				_last_added_note.selected = true
			else:
				_last_added_note.selected = false
				_last_added_note.skip_notification = false
				_last_added_note._signal_modification()


func add_note(event: Track.Event):
	var note := _create_note()
	note.set_note_relative_position(event.position)
	note.skip_notification = false


func _create_note() -> NoteUI:
	var note := _note_scene.instance() as NoteUI
	# warning-ignore:return_value_discarded
	get_parent().editor.connect("snap_changed", note, "_on_snap_changed")
	note.snap = get_parent().editor.snap
	add_child(note)
	return note
