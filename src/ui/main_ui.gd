extends Control
class_name MainUI

export var track: NodePath

onready var _tempo_spinbox = $VBoxContainer/TopBar/HBoxContainer/Tempo
onready var _play_button = $VBoxContainer/TopBar/HBoxContainer/Transport/Play
onready var _pause_button = $VBoxContainer/TopBar/HBoxContainer/Transport/Pause
onready var _stop_button = $VBoxContainer/TopBar/HBoxContainer/Transport/Stop
onready var _groove_list = $VBoxContainer/TabContainer/Grooves/ScrollContainer/VBoxContainer

var _track: Track
var _groove_scene = preload("res://ui/groove.tscn")

func _ready():
	_track = get_node(track)
	_tempo_spinbox.connect("value_changed", _track, "set_tempo")
	_track.tempo = _tempo_spinbox.value
	_play_button.connect("pressed", _track, "play")
	_pause_button.connect("pressed", _track, "toggle_pause")
	_stop_button.connect("pressed", _track, "stop")


func add_groove(groove: Track.Groove) -> GrooveItemUI:
	var entry = _groove_scene.instance() as GrooveItemUI
	entry.set_groove_name(groove.name)
	entry.set_tags(groove.tags)
	_groove_list.add_child(entry, true)
	return entry
