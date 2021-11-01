extends Control
class_name GrooveEditorUI

signal signature_changed(note_value, beats_per_bar)
signal length_changed(value)
signal div_per_beat_changed(value)
signal snap_changed(state)

onready var _signature := $GridContainer/Controls/Signature
onready var _length := $GridContainer/Controls/Length
onready var _grid := $GridContainer/Controls/Grid
onready var _snap := $GridContainer/Controls/Snap


var note_value := 4
var beats_per_bar := 4
var length := 4
var div_per_beat := 4
var snap := false

func _ready():
	# warning-ignore:return_value_discarded
	_signature.connect("text_changed", self, "_on_signature_changed")
	# warning-ignore:return_value_discarded
	_length.connect("value_changed", self, "_on_length_changed")
	# warning-ignore:return_value_discarded
	_grid.connect("item_selected", self, "_on_grid_changed")
	# warning-ignore:return_value_discarded
	_snap.connect("toggled", self, "_on_snap_changed")
	_on_grid_changed(_grid.get_selected_id())


func _on_signature_changed(sig: String):
	var tokens = sig.split('/')
	if tokens.size() == 2:
		var new_beats_per_bar: int = tokens[0].to_int()
		var new_note_value: int = tokens[1].to_int()
		if new_beats_per_bar != beats_per_bar or new_note_value != note_value:
			beats_per_bar = new_beats_per_bar
			note_value = new_note_value
			emit_signal("signature_changed", note_value, beats_per_bar)
	_signature.text = String(beats_per_bar) + "/" + String(note_value)


func _on_length_changed(new_length: int):
	if length != new_length:
		length = new_length
		print("new length: ", length)
		emit_signal("length_changed", length)


func _on_grid_changed(idx: int):
	var new_div_per_beat: int
	match idx:
		0:
			new_div_per_beat = 0
		1:
			new_div_per_beat = 1
		_:
			new_div_per_beat = _pow2(idx)
	if new_div_per_beat != div_per_beat :
		div_per_beat = new_div_per_beat
		print("div_per_beat changed: ", div_per_beat)
		emit_signal("div_per_beat_changed", div_per_beat)


func _on_snap_changed(state: bool):
	emit_signal("snap_changed", state)
	if snap != state:
		snap = state


func _pow2(power: int) -> int:
	var res := 1
	for _i in range(power):
		res *= 2
	return res
