extends ColorRect
class_name Note

onready var _tracks := get_parent().get_parent() 
var _selected := false
var _snap := false


func _ready():
	rect_global_position.y = get_parent().rect_global_position.y + (get_parent().rect_size.y - rect_size.y) / 2


func _process(_delta: float):
	if _selected:
		rect_global_position.x = clamp(
			get_global_mouse_position().x, 
			get_parent().rect_global_position.x, 
			get_parent().rect_global_position.x + get_parent().rect_size.x)
		if _snap:
			var closest := 1000000.0
			for snap_loc in _tracks.snap_locations:
				var dist := abs(rect_position.x - snap_loc)
				if dist < closest:
					rect_position.x = snap_loc
					closest = dist


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			_selected = mouse_event.pressed
			print("note selected: ", _selected)


func _on_snap(state: bool):
	_snap = state
