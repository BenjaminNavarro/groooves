extends Control
class_name GrooveTracksUI

export(Color) var line_color: Color
export(float) var line_width := 1.0

var snap_locations := Array()


func _ready():
	pass


func _draw():
	var divs = 4
	var lines = divs
	snap_locations.clear()
	for i in range(lines):
		var x_pos = i * (rect_size.x / lines)
		var y_start = 0
		var y_end = rect_size.y
		draw_line(Vector2(x_pos, y_start), Vector2(x_pos, y_end), line_color, line_width)
		snap_locations.push_back(x_pos)
