extends Sprite2D

@onready var jewel_highlight: Sprite2D = $jewel_highlight
@export var jewel_sprites: Array[Sprite2D]
@onready var selector: Sprite2D = $Selector

var Selected: int = 0


func _ready():
	$"..".jewel_palette = self

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
	$"..".selected_jewel = n
	selector.global_position = jewel_sprites[n].global_position

func show_palette():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,-539.0),0.2)

func hide_palette():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,-722.0),0.2)
