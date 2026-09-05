extends Sprite2D

@onready var jewel_highlight: Sprite2D = $jewel_highlight
@export var jewel_sprites: Array[Sprite2D]
@onready var selector: Sprite2D = $Selector

var Selected: int = 0

var table: Table

func _on_jewel_mouse_entered(n: int) -> void:
	if n >= jewel_sprites.size():
		push_error("CONNECT THE JEWEL DUMBASS")
		return
	jewel_sprites[n].scale = Vector2(1.1,1.1)
	jewel_highlight.show()
	jewel_highlight.global_position = jewel_sprites[n].global_position

func _on_jewel_mouse_exited(n: int) -> void:
	if n >= jewel_sprites.size():
		push_error("CONNECT THE JEWEL DUMBASS")
		return
	jewel_sprites[n].scale = Vector2(1.0,1.0)
	jewel_highlight.hide()

func _on_jewel_button_down(n: int) -> void:
	n = n % 8
	Selected = n
	table.selected_jewel = n
	selector.global_position = jewel_sprites[n].global_position

func show_palette():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,-539.0),0.2)

func hide_palette():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,-722.0),0.2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("WheelUp"):	_on_jewel_button_down(Selected+1)
	if event.is_action_pressed("WheelDown"):	_on_jewel_button_down(Selected-1)
	elif event.is_action_pressed("1"):	_on_jewel_button_down(0)
	elif event.is_action_pressed("2"):	_on_jewel_button_down(1)
	elif event.is_action_pressed("3"):	_on_jewel_button_down(2)
	elif event.is_action_pressed("4"):	_on_jewel_button_down(3)
	elif event.is_action_pressed("5"):	_on_jewel_button_down(4)
	elif event.is_action_pressed("6"):	_on_jewel_button_down(5)
	elif event.is_action_pressed("7"):	_on_jewel_button_down(6)
	elif event.is_action_pressed("8"):	_on_jewel_button_down(7)
