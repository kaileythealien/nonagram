extends Node

var table: Table

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NextPage"):
		table._on_next_page_button_down()
	elif event.is_action_pressed("PreviousPage"):
		table._on_previous_page_button_down()
	elif event.is_action_pressed("Autosolve"):
		table.page.DebugAutosolve()
