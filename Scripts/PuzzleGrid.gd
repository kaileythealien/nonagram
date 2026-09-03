extends TileMapLayer

@onready var cursor: AnimatedSprite2D

@onready var page: Page = $"../../.."

@onready var tiles: TileMapLayer = $".."
@onready var solution: TileMapLayer = $"../Solution"

var mouse_left_down: bool = false
var mouse_right_down: bool = false
var table: Node2D

var is_curson_shown: bool = false

func _ready() -> void:
	solution.hide()
	#page.GridsToSave.append(self)
	table = get_tree().current_scene
	
	pass

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
		elif event.button_index == 2 and event.is_pressed():
			mouse_right_down = true
		elif event.button_index == 2 and not event.is_pressed():
			mouse_right_down = false
	
	if mouse_left_down:
		var gridpos: Vector2i = local_to_map(get_global_mouse_position()/global_scale.x-global_position)
		if tiles.get_cell_atlas_coords(gridpos) == Vector2i(0,0):
			set_cell(gridpos,0,table.jewel_array[table.selected_jewel])
	elif mouse_right_down:
		var gridpos: Vector2i = local_to_map(get_global_mouse_position()/global_scale.x-global_position)
		if tiles.get_cell_atlas_coords(gridpos) == Vector2i(0,0):
			set_cell(gridpos)
	else:
		if not cursor: return
		var gridpos: Vector2i = local_to_map(get_global_mouse_position()/global_scale.x-global_position)
		if tiles.get_cell_atlas_coords(gridpos) == Vector2i(0,0):
			is_curson_shown = true
			cursor.show()
			cursor.global_position = self.map_to_local(gridpos)*global_scale.x+global_position
			cursor.global_scale = global_scale/1.1
		elif is_curson_shown:
			cursor.hide()
			is_curson_shown = false
