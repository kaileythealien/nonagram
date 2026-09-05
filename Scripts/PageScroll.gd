extends Node

var table: Table

func GoToPageByNumber(to_page: int) -> void:
	if table.is_turning_page: return
	
	var currentPage: int = table.currentPage
	var get_page_controller: Node = table.get_page_controller
	
	# NOT LET GO TO SAME PAGE
	if to_page == currentPage: return
	
	# GET DIRECTION
	var forward: bool = to_page > currentPage
	
	# GET PATH TO PAGE SCENE
	var path_to_page: String = get_page_controller.GetPathFromID(to_page)
	if not ResourceLoader.exists(path_to_page): 
		print("FAILED")
		return
	
	SaveSystem.SavePage(table.page)
	table.is_turning_page = true
	table.return_to_previous_button.hide_return_to_current()
	table.currentPage = to_page
	
	table.FlipPageTo(path_to_page, forward)

func GoToPageByDefinition(to_def: String, allow_return: bool = false):
	if table.is_turning_page: return
	
	var currentPage: int = table.currentPage
	var get_page_controller: Node = table.get_page_controller
	
	# NOT LET GO TO SAME PAGE
	if str_to_var(to_def) == currentPage: return
	
	var arr: Array = get_page_controller.GetPathByDefinition(to_def)
	var page_num: int = arr[1]
	
	# NOT LET GO TO SAME ROOM
	if page_num == currentPage: return
	# NOT LET GO TO SOME BS UNDEFINES NUMBER
	if page_num == 0: return
	
	table.lastPage = currentPage
	if allow_return:
		table.return_to_previous_button.show_return_to_current()
	
	# GET DIRECTION
	var forward: bool = page_num > currentPage
	
	# GET PATH TO PAGE SCENE
	var path_to_page: String = arr[0]
	if not ResourceLoader.exists(path_to_page): 
		print("FAILED")
		return
	
	SaveSystem.SavePage(table.page)
	table.is_turning_page = true
	table.currentPage = arr[1]
	
	table.FlipPageTo(path_to_page, forward)

func GoToPageByPath(path: String, allow_return: bool = false) -> void:
	if table.is_turning_page: return
	
	var currentPage: int = table.currentPage
	var get_page_controller: Node = table.get_page_controller
	
	var to_page: int = get_page_controller.getIDFromPath(path)
	if to_page == -1: return
	
	# NOT LET GO TO SAME PAGE
	if to_page == currentPage: return
	# GET DIRECTION
	var forward: bool = to_page > currentPage
	
	# GET PATH TO PAGE SCENE
	var path_to_page: String = get_page_controller.GetPathFromID(to_page)
	if not ResourceLoader.exists(path_to_page): 
		print("FAILED")
		return
	
	table.lastPage = currentPage
	if allow_return:
		table.return_to_previous_button.show_return_to_current()
	
	SaveSystem.SavePage(table.page)
	table.is_turning_page = true
	table.currentPage = to_page
	
	table.FlipPageTo(path_to_page, forward)
