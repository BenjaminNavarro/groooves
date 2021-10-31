extends Control
class_name GrooveEditorUI

onready var _signature := $GridContainer/Controls/Signature
onready var _length := $GridContainer/Controls/Length
onready var _grid := $GridContainer/Controls/Grid
onready var _snap := $GridContainer/Controls/Snap

func _ready():
	var notes = get_tree().get_nodes_in_group("notes")
	for note in notes:
		_snap.connect("toggled", note, "_on_snap")
