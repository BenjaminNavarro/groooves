extends Panel
class_name GrooveItemUI

signal selected

export var groove_name: String setget set_groove_name
export(Array, String) var groove_tags: Array setget set_tags

var _tag_scene = preload("res://ui/tag.tscn")


func set_tags(tags: Array):
	clear_tags()
	for tag in tags:
		add_tag(tag)

func set_groove_name(new_name: String):
	groove_name = new_name
	_name().text = new_name


func clear_tags():
	for tag in _tags().get_children():
		tag.queue_free()


func add_tag(tag_name: String):
	var tag = _tag_scene.instance()
	tag.set_text(tag_name)
	_tags().add_child(tag)


func _name() -> Label:
	return $MarginContainer/HBoxContainer/Name as Label
	
	
func _tags() -> HBoxContainer:
	return $MarginContainer/HBoxContainer/Tags as HBoxContainer


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT and mouse_event.pressed:
			print("goove ", groove_name, " selected")
			emit_signal("selected")
