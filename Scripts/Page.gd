class_name Page extends Node2D


### SAVING
var path_to_page: String = "default"
@export var GridsToSave: Array[TileMapLayer]
var is_solution_correct: bool = false
var has_been_touched: bool = false
@export var is_next_page_locked: bool = false

### VISUAL
@export var is_cover_page: bool = false
var is_looking_up_definition: bool = false
var looking_up_from_page: int = 0
signal animation_finished
@export var lock: Sprite2D

### CONSTANT
@export var page_turn_speed: float = 0.05
@onready var right_page: Sprite2D = $RightPage
@onready var left_page: Sprite2D = $LeftPage
var table: Table

func _ready() -> void:
	table = $".."
	
	#z_index = -page_number
	right_page.scale.x = 0
	left_page.scale.x = 0
	if GridsToSave != []:
		var cursorRes: Resource = load("res://cursor.tscn")
		var cursorScene = cursorRes.instantiate()
		add_child(cursorScene)
		for tileset in GridsToSave:
			tileset.cursor = cursorScene

func PreOpen(forward:bool):
	if forward:
		right_page.scale.x = 1
	else:
		left_page.scale.x = 1

func Open(forward:bool):
	
	var tween = get_tree().create_tween()
	
	if forward:
		tween.tween_property(left_page,"scale",Vector2(1,1), page_turn_speed)
	else:
		tween.tween_property(right_page,"scale",Vector2(1,1), page_turn_speed)
	
	await tween.finished
	animation_finished.emit()

func Close(forward:bool):
	
	var tween = get_tree().create_tween()
	
	if forward:
		tween.tween_property(right_page,"scale",Vector2(0,1), page_turn_speed)
	else:
		tween.tween_property(left_page,"scale",Vector2(0,1), page_turn_speed)
	
	await tween.finished
	animation_finished.emit()

func SavePage() -> Dictionary:
	var tile_data_array: Array[String]
	
	is_solution_correct = true
	
	for grid_id in GridsToSave:
		#---------------#
		#IF ERROR RETURN
		#---------------#
		if grid_id == null:
			push_warning(str(grid_id) + " Has grids to save, but no grid attached!")
			break
		
		#---------------#
		#GET DATA
		#---------------#
		var tilemap_data: String = grid_id.TilesetToString()
		tile_data_array.append(tilemap_data)
		
		#---------------#
		#CHECK SOLUTION
		#---------------#
		
		var solution_data: String = grid_id.TilesetToString(grid_id.solution)
		if tilemap_data != solution_data:
			is_solution_correct = false
			print_rich("[i][color=dim_gray]Solution not correct. Required[color=yellow] " + solution_data
			+ "[color=dim_gray], but recieved [color=yellow]" + tilemap_data + "[/color]")
		else:
			print_rich("[i][color=dim_gray]Solution correct. ([color=green]" + tilemap_data + "[color=dim_gray])" + "[/color]")
	
	#---------------#
	#COMPILE DICT
	#---------------#
	var dict_to_return: Dictionary[Variant, Variant] = {
		"path_to_page" : path_to_page,
		"tile_data" : tile_data_array,
		"is_solved": is_solution_correct,
		"has_been_touched": has_been_touched,
		"is_next_page_locked": is_next_page_locked
	}
	
	return dict_to_return

func LoadPage(page_data):
	
	if page_data.is_empty(): return
	
	if lock and not page_data["is_next_page_locked"]:
		lock.SkipToWin()
	
	#IF DOESNT NEED LOADING
	if GridsToSave.is_empty(): return
	if not page_data.keys().has("tile_data"): return
	
	#FOR EACH GRID SET THE GRID TO GRID DUH
	for grid_id in GridsToSave.size():
		GridsToSave[grid_id-1].StringToTileset(page_data["tile_data"][grid_id-1])
		continue
	
	is_solution_correct = page_data["is_solved"]
	has_been_touched = page_data["has_been_touched"]
	is_next_page_locked = page_data["is_next_page_locked"]
	
	
	


func LookupDefinition(id: String, allow_return: bool):
	table.GoToPageByDefinition(id,allow_return)
