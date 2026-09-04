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
	
	# PLACE TILE
	if mouse_left_down:
		var gridpos: Vector2i = local_to_map(get_global_mouse_position()/global_scale.x-global_position)
		if solution.get_cell_atlas_coords(gridpos) != Vector2i(-1,-1):
			set_cell(gridpos,0,table.jewel_array[table.selected_jewel])
			page.has_been_touched = true
	# ERASE TILE
	elif mouse_right_down:
		var gridpos: Vector2i = local_to_map(get_global_mouse_position()/global_scale.x-global_position)
		if solution.get_cell_atlas_coords(gridpos) != Vector2i(-1,-1):
			set_cell(gridpos)
	else:
		# CURSOR
		if not cursor: return
		var gridpos: Vector2i = local_to_map(get_global_mouse_position()/global_scale.x-global_position)
		if solution.get_cell_atlas_coords(gridpos) != Vector2i(-1,-1):
			is_curson_shown = true
			cursor.show()
			cursor.global_position = self.map_to_local(gridpos)*global_scale.x+global_position
			cursor.global_scale = global_scale/1.1
		elif is_curson_shown:
			cursor.hide()
			is_curson_shown = false

func TilesetToString(tilset_to_convert: TileMapLayer = self) -> String:
	var string_to_return: String = ""
	
	var usedtiles: Array[Vector2i] = solution.get_used_cells()
	usedtiles.sort()
	
	for tile_pos in usedtiles:
		var tile: Vector2i = tilset_to_convert.get_cell_atlas_coords(tile_pos)
		match tile:
			Vector2i(0,3): string_to_return += "b"
			Vector2i(1,3): string_to_return += "w"
			Vector2i(2,3): string_to_return += "a"
			Vector2i(3,3): string_to_return += "u"
			Vector2i(0,4): string_to_return += "1"
			Vector2i(1,4): string_to_return += "2"
			Vector2i(2,4): string_to_return += "3"
			Vector2i(3,4): string_to_return += "4"
			_: string_to_return += "o"
		
	return string_to_return

func StringToTileset(StringifiedTileset: String) -> void:
	
	var usedtiles: Array[Vector2i] = solution.get_used_cells()
	usedtiles.sort()
	
	var tile_cursor: int = 0
	for character in StringifiedTileset:
		var tile: Vector2i = usedtiles[tile_cursor]
		match character:
			"b": set_cell(tile,0,Vector2i(0,3))
			"w": set_cell(tile,0,Vector2i(1,3))
			"a": set_cell(tile,0,Vector2i(2,3))
			"u": set_cell(tile,0,Vector2i(3,3))
			"1": set_cell(tile,0,Vector2i(0,4))
			"2": set_cell(tile,0,Vector2i(1,4))
			"3": set_cell(tile,0,Vector2i(2,4))
			"4": set_cell(tile,0,Vector2i(3,4))
			_: set_cell(tile)
		tile_cursor += 1
		
	return 
