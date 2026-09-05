extends Button

var table: Table

func show_return_to_current() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(-300.0,356.0),0.2)

func hide_return_to_current() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(-300.0,542.0),0.2)

func _on_button_down() -> void:
	PageScroll.GoToPageByNumber(table.lastPage)
