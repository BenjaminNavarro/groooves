extends Node
class_name Track

enum Note {
	Kick,
	Snare,
	ClosedHighHat
}

class Event:
	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	func _init(note: int, velocity: float, position: float):
		self.note = note
		self.velocity = velocity
		self.position = position

	var note: int # Track.Note
	var velocity: float
	var position: float # in beats


class Groove:
	func _init():
		events = Array()
		tags = Array()
		length = 0

	var name: String
	var tags: Array
	var events: Array
	var length: float

	static func from_json(json_str: String) -> Groove:
		var json = JSON.parse(json_str)
		if typeof(json.result) == TYPE_DICTIONARY:
			var groove := Groove.new()
			groove.name = json.result["name"]
			groove.tags = json.result["tags"]
			groove.length = json.result["length"]
			for event in json.result["events"]:
				groove.events.push_back(
					Event.new(Note.keys().find(event["note"]), event["velocity"], event["position"])
				)
			return groove
		else:
			print("Invalid groove JSON")
			return null


signal generate_note(event)
signal nextgroove()

export(float, 20, 240) var tempo: float setget set_tempo
export(int, 1, 20) var timers: int

enum State {
	Playing,
	Paused,
	Stopped
}

var groove: Groove setget set_groove
var state:int = State.Stopped setget ,get_state

onready var _timers := $Timers

func play():
	if not groove:
		return
	stop()
	for event in groove.events:
		var ev = event as Event
		var timer = create_timer(_beat_pos_to_sec(ev.position))
		timer.connect("timeout", self, "_generate_note", [ev])
		timer.connect("timeout", timer, "stop")
		timer.start()
	var timer := create_timer(_beat_pos_to_sec(groove.length))
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "groove_finished")
	timer.start()
	state = State.Playing


func toggle_pause():
	if not groove or state == State.Stopped:
		return

	for obj in _timers.get_children():
		var timer = obj as Timer
		timer.paused = not timer.paused;

	if state == State.Playing:
		state = State.Paused
	else:
		state = State.Playing

func stop():
	if not groove:
		return
	for timer in _timers.get_children():
		timer.stop()
		timer.queue_free()
	state = State.Stopped


func set_tempo(new_tempo: float):
	if _timers:
		var time_scale := tempo / new_tempo
		for obj in _timers.get_children():
			var timer = obj as Timer
			if timer.time_left > 0.00001:
				var new_time: float = timer.time_left * time_scale
				timer.start(new_time)
	tempo = new_tempo


func set_groove(new_groove: Groove):
	groove = new_groove
	play()


func get_state():
	return state


func _generate_note(event: Event):
	emit_signal("generate_note", event)


func groove_finished():
	emit_signal("nextgroove")
	play()


func create_timer(wait_time: float) -> Timer:
	var timer = Timer.new()
	_timers.add_child(timer)
	timer.one_shot = true
	timer.wait_time = wait_time
	return timer


func _beat_pos_to_sec(pos: float):
	var beat_length := 60.0 / tempo
	var secs := pos * beat_length
	if secs <= 0.0:
		return 0.0001
	else:
		return secs
