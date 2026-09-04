class_name Table extends Node2D

var page: Page
var NextPage: Page
var currentPage: int = 0

var lastPage: int = 0
var show_return_to_previous_page: bool = false

var is_turning_page: bool = false

var book_id: String = "A"

var selected_jewel: int = 0
@export var jewel_array: Array[Vector2i]

@export var get_page_controller: GetPageController
@export var return_to_previous_button: Button
@export var jewel_palette: Sprite2D


func _ready() -> void:
	page = $Page
	page.PreOpen(currentPage)
	
	SaveSystem.table = self
	PageScroll.table = self
	
	return_to_previous_button.table = self
	jewel_palette.table = self

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
	SaveSystem.LoadPage(NextPage)
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
	#CHECKS IF PAGE IS LCOKED
	if page.is_next_page_locked: return
	PageScroll.GoToPageByNumber(currentPage + 1)

func _on_previous_page_button_down() -> void:
	PageScroll.GoToPageByNumber(currentPage - 1)

func _on_bookmark_button_down() -> void:
	PageScroll.GoToPageByDefinition("Summary")
