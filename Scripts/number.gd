extends Button

var doubleclick_timer: int
@export var requires_double_click: bool = true
@export var override_page_path: Page

func _ready() -> void:
	$Label.text = text
	text = ""

func _process(delta: float) -> void:
	if doubleclick_timer > 0:
		doubleclick_timer -= delta

func _on_button_down() -> void:
	if doubleclick_timer > 0 or (not requires_double_click):
		if override_page_path == null:
			$"../..".LookupDefinition($Label.text)
		else:
			override_page_path.LookupDefinition($Label.text)
		return
	doubleclick_timer = 50
