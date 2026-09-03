extends Node

var SavedTilesets: Dictionary[String,Array]

@export var do_save: bool = false

func _ready() -> void:
	get_tree().auto_accept_quit = false
	Load()

func Load():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(save_file.get_as_text())
	if parse_err != OK: return
	var dict = json_object.get_data()
	if dict is Dictionary:
		for dict_page in dict:
			var dict_tilesets_on_page: Array
			for dict_tileset in dict[dict_page]:
				if dict_tileset is String:
					dict_tilesets_on_page.append(str_to_var(dict_tileset))
				elif dict_tileset is Array:
					dict_tilesets_on_page.append(dict_tileset)
				SavedTilesets.set(dict_page,dict_tilesets_on_page)

func Save():
	if not do_save:
		FileAccess.open("user://savegame.save", FileAccess.WRITE)
		return
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(SavedTilesets)
	save_file.store_line(json_string)
