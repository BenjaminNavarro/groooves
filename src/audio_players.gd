extends Node
class_name AudioPlayers

export var track: NodePath

var _track: Track
onready var _kick := $KickPlayer 
onready var _snare := $SnarePlayer 
onready var _high_hat := $HighHatPlayer 


func _ready():
	_track = get_node(track)
	_track.connect("generate_note", self, "_on_generate_note")
	for obj in get_children():
		var player := obj as AudioStreamPlayer
		player.stream.loop = false


func _on_generate_note(event: Track.Event):
	if event.note == Track.Note.Kick:
		_kick.play()
	elif event.note == Track.Note.Snare:
		_snare.play()
	elif event.note == Track.Note.ClosedHighHat:
		_high_hat.play()
