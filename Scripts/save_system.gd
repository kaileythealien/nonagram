extends Node

var SavedData: Dictionary

@export var do_save: bool = true

var table: Table

func _ready() -> void:
	get_tree().auto_accept_quit = false
	LoadGame()

func SavePage(_page: Page):
	# TELLS PAGE TO SAVE THE TILESET STATES AND STORES THEM IN SAVE DICT
	var page_save_dict: Dictionary = _page.SavePage()
	
	#IF NOT NEEDED
	if not page_save_dict: return
	if page_save_dict["tile_data"] == []: return
	
	var pageid: String = page_save_dict["path_to_page"]
	
	SavedData.set(pageid,page_save_dict)
	

func LoadPage(_page: Page):
	# GIVES PAGE TILESETS TO LOAD AND TELLS IT TO LOAD THEM
	var pageid: String = _page.path_to_page
	if not SavedData.keys().has(pageid): return
	
	_page.LoadPage(SavedData[pageid])

func LoadGame():
	#GET THE FILE AND SHIT
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(save_file.get_as_text())
	if parse_err != OK: return
	var dict = json_object.get_data()
	
	"""
	#SOME CRAZY MAGIC HAPPENING HERE I JUST HOPE ILL NEVER HAVE TO TOUCH IT AGAIN
	#---------------------#
	#in all seriousness this mess is supposed to transform "tile_data" of each page from string to
	#array because its store incorrectly, then replace it in the dict variable after which it just
	#sets SavedTilesets to dict. hope this helps, future me))))))
	if dict is Dictionary:
		for dict_page in dict:
			var dict_tilesets_on_page: Array
			for dict_tileset in dict[dict_page]["tile_data"]:
				if dict_tileset is String:
					dict_tilesets_on_page.append(str_to_var(dict_tileset))
				elif dict_tileset is Array:
					dict_tilesets_on_page.append(dict_tileset)
			dict[dict_page]["tile_data"] = dict_tilesets_on_page
	#---------------------#
	"""
	
	if dict != {}:
		SavedData = dict
		print(SavedData)

func SaveGame():
	if not do_save:
		FileAccess.open("user://savegame.save", FileAccess.WRITE)
		return
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(SavedData)
	save_file.store_line(json_string)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#CODE THAT MAKES YOU'RE PENIS LARGER (AND SAVES THE GAME ON APPLICATION QUIT)
		SavePage(table.page)
		SaveGame()
		get_tree().quit()
