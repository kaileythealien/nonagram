class_name Table extends Node2D

var page: Page
var NextPage: Page
var currentPage: int = 0
var is_turning_page: bool = false

@onready var jewel_palette: Sprite2D

var book_id: String = "A"

var selected_jewel: int = 0
@export var jewel_array: Array[Vector2i]

@export var save_system: Node
@export var get_page_controller: GetPageController


func _ready() -> void:
	page = $Page
	page.PreOpen(currentPage)
	save_system.table = self

func GoToPageByNumber(to_page: int):
	if is_turning_page: return
	
	# NOT LET GO TO SAME PAGE
	if to_page == currentPage: return
	
	# GET DIRECTION
	var forward: bool = to_page > currentPage
	
	# GET PATH TO PAGE SCENE
	var path_to_page: String = get_page_controller.GetPathFromID(to_page)
	if not ResourceLoader.exists(path_to_page): 
		print("FAILED")
		return
	
	save_system.SavePage(page)
	is_turning_page = true
	currentPage = to_page
	
	FlipPageTo(path_to_page, forward)

func GoToPageByDefinition(to_def: String):
	if is_turning_page: return
	
	# NOT LET GO TO SAME PAGE
	if str_to_var(to_def) == currentPage: return
	
	var arr: Array = get_page_controller.GetPathByDefinition(to_def)
	
	# NOT LET GO TO SAME ROOM
	if arr[1] == currentPage: return
	# NOT LET GO TO SOME BS UNDEFINES NUMBER
	if arr[1] == 0: return

	# GET DIRECTION
	var forward: bool = arr[1] > currentPage
	
	# GET PATH TO PAGE SCENE
	var path_to_page: String =  arr[0]
	if not ResourceLoader.exists(path_to_page): 
		print("FAILED")
		return
	
	save_system.SavePage(page)
	is_turning_page = true
	currentPage = arr[1]
	
	FlipPageTo(path_to_page, forward)

func FlipPageTo(path_to_page: String, forward: bool = false):
	
	# CREATING PAGE
	var PageScene: Resource = load(path_to_page)
	var PageInstance = PageScene.instantiate()
	NextPage = PageInstance
	NextPage.z_index = -5
	page.z_index = 5
	add_child(PageInstance)
	NextPage.path_to_page = path_to_page
	
	# SHOWING / HIDING PALETTE UI
	if NextPage.GridsToSave != []:
		jewel_palette.show_palette()
	else:
		jewel_palette.hide_palette()
	
	# ANIMATION FIRST HALF
	NextPage.PreOpen(forward)
	save_system.LoadPage(NextPage)
	page.Close(forward)
	await page.animation_finished
	# ANIMATION SECOND HALF
	NextPage.Open(forward)
	NextPage.z_index = 5
	page.z_index = -5
	await NextPage.animation_finished
	
	# REMOVE OLD PAGE AND CLEAN UP
	page.queue_free()
	page = NextPage
	is_turning_page = false



func _on_next_page_button_down() -> void:
	GoToPageByNumber(currentPage + 1)

func _on_previous_page_button_down() -> void:
	GoToPageByNumber(currentPage - 1)



func _on_bookmark_button_down() -> void:
	GoToPageByDefinition("Summary")
