extends Control
class_name GrooveTrackUI


var _note_scene := preload("res://ui/note.tscn")


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT and mouse_event.pressed:
			var note := _note_scene.instance() as NoteUI
			# warning-ignore:return_value_discarded
			get_parent().editor.connect("snap_changed", note, "_on_snap_changed")
			note.snap = get_parent().editor.snap
			add_child(note)
			note.set_note_global_position(get_global_mouse_position().x)
