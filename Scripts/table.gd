extends Node2D

var page: Page
var NextPage: Page
var currentPage: int = 0
var is_turning_page: bool = false

@onready var jewel_palette: Sprite2D

var book_id: String = "A"

var selected_jewel: int = 0
@export var jewel_array: Array[Vector2i]

@export var pages_numbers: Dictionary
@onready var save_system: Node = $SaveSystem
@onready var get_page_controller: GetPageController = $GetPageController


func _ready() -> void:
	page = $Page
	page.PreOpen(currentPage)

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
	
	SavePage(page)
	is_turning_page = true
	currentPage = to_page
	
	FlipPageTo(path_to_page, forward)

func GoToPageByDefinition(to_def: String):
	if is_turning_page: return
	
	# NOT LET GO TO SAME PAGE
	if str_to_var(to_def) == currentPage: return
	
	var arr: Array = get_page_controller.GetPathByDefinition(to_def)
	
	# NOT LET GO TO SOME BS UNDEFINES NUMBER
	if arr[1] == 0: return
	
	# GET DIRECTION
	var forward: bool = arr[1] > currentPage
	
	# GET PATH TO PAGE SCENE
	var path_to_page: String =  arr[0]
	if not ResourceLoader.exists(path_to_page): 
		print("FAILED")
		return
	
	SavePage(page)
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
	
	# SHOWING / HIDING PALETTE UI
	if NextPage.GridsToSave != []:
		jewel_palette.show_palette()
	else:
		jewel_palette.hide_palette()
	
	# ANIMATION FIRST HALF
	NextPage.PreOpen(forward)
	LoadPage(NextPage)
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

func SavePage(_page: Page):
	# TELLS PAGE TO SAVE THE TILESET STATES AND STORES THEM IN SAVE DICT
	var tilesets_on_page: Array = _page.SavePage()
	if not tilesets_on_page: return
	var pageid: String = str(book_id) + str(currentPage)
	save_system.SavedTilesets.set(pageid,tilesets_on_page)

func LoadPage(_page: Page):
	# GIVES PAGE TILESETS TO LOAD AND TELLS IT TO LOAD THEM
	var pageid: String = str(book_id) + str(currentPage)
	if not save_system.SavedTilesets.keys().has(pageid): return
	_page.LoadPage(save_system.SavedTilesets[pageid])



func _on_next_page_button_down() -> void:
	GoToPageByNumber(currentPage + 1)

func _on_previous_page_button_down() -> void:
	GoToPageByNumber(currentPage - 1)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SavePage(page)
		save_system.Save()
		get_tree().quit()

func _on_bookmark_button_down() -> void:
	GoToPageByDefinition("Summary")
