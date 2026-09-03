extends Button

var doubleclick_timer: int
@export var override_page_path: Page
@export var page_search_tag: String = ""
@export var selector_char: String = "⮚ "

@onready var label: Label = $Label
var full_text: String

func _ready() -> void:
	full_text = label.text

func _process(delta: float) -> void:
	if doubleclick_timer > 0:
		doubleclick_timer -= delta

func _on_button_down() -> void:
	
	var txt: String
	if page_search_tag == "":
		txt = text
	else:
		txt = page_search_tag
	override_page_path.LookupDefinition(txt)
	

func _on_mouse_entered() -> void:
	label.text = selector_char + full_text
	label.modulate = Color(0.51, 0.255, 0.0, 1.0)

func _on_mouse_exited() -> void:
	label.text = full_text
	label.modulate = Color(0.51, 0.255, 0.0, 0.6)
