extends Button

var doubleclick_timer: float
@export var requires_double_click: bool = true

func _ready() -> void:
	$Label.text = text
	text = ""

func _process(delta: float) -> void:
	if doubleclick_timer > 0:
		doubleclick_timer -= delta

func _on_button_down() -> void:
	if doubleclick_timer > 0 or (not requires_double_click):
		PageScroll.GoToPageByDefinition($Label.text, true)
		return
	doubleclick_timer = 0.2
