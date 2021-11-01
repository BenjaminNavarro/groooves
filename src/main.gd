extends Node


onready var ui := $UI

var _grooves: Array


func _ready():
	_grooves = Array()
	var grooves_dir = Directory.new()
	if grooves_dir.open("res://assets/grooves") == OK:
		grooves_dir.list_dir_begin(true, true)
		var file_name = grooves_dir.get_next()
		while file_name != "":
			file_name = "res://assets/grooves/" + file_name
			var groove_file = File.new()
			groove_file.open(file_name, File.READ)
			var groove = Track.Groove.from_json(groove_file.get_as_text())
			_grooves.push_back(groove)
			var groove_ui := ui.add_groove(groove) as GrooveItemUI
			# warning-ignore:return_value_discarded
			groove_ui.connect("selected", self, "_on_groove_selection", [groove])
			file_name = grooves_dir.get_next()


func _on_groove_selection(groove: Track.Groove):
	$Track.groove = groove
	ui.groove_editor.clear()
	ui.groove_editor.set_length(groove.length)
	for note in groove.events:
		ui.groove_editor.add_note(note)
