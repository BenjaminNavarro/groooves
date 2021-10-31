extends Label

const themes = {"rock": "res://ui/tags/rock.theme", "blues": "res://ui/tags/blues.theme"}


func set_text(text: String):
	.set_text(text)
	theme = load(themes[text])
