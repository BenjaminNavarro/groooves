extends Control
class_name GrooveEditorUI

onready var _signature := $GridContainer/Controls/Signature
onready var _length := $GridContainer/Controls/Length
onready var _grid := $GridContainer/Controls/Grid
onready var _snap := $GridContainer/Controls/Snap

func _ready():
	var notes = get_tree().get_nodes_in_group("notes")
	for note in notes:
		# warning-ignore:return_value_discarded
		self.connect("snap_changed", note, "_on_snap_changed")
