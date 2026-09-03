class_name Page extends Node2D

@export var is_cover_page: bool = false
@export var page_number: int = 0
@export var book_id: String = "A"
@export var page_turn_speed: float = 0.1

@onready var right_page: Sprite2D = $RightPage
@onready var left_page: Sprite2D = $LeftPage

signal animation_finished

var is_solution_correct: bool = false

var is_looking_up_definition: bool = false
var looking_up_from_page: int = 0

@export var GridsToSave: Array[TileMapLayer]

func _ready() -> void:
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

func SavePage():
	var array_to_return: Array[PackedByteArray]
	is_solution_correct = true
	for grid_id in GridsToSave:
		if grid_id == null:
			push_warning(str(grid_id) + " has grids to save, but no grid attached!")
			return []
		var tilemap_data: PackedByteArray = grid_id.tile_map_data
		if tilemap_data != grid_id.solution.tile_map_data:
			is_solution_correct = false
		array_to_return.append(tilemap_data)
	print("SOLUTION IS " + str(is_solution_correct))
	return array_to_return

func LoadPage(array_tilesets):
	if GridsToSave.is_empty(): return
	if array_tilesets.is_empty(): return
	for grid_id in GridsToSave.size():
		GridsToSave[grid_id-1].tile_map_data = array_tilesets[grid_id-1]
	pass

func LookupDefinition(id: String):
	$"..".GoToPageByDefinition(id)
