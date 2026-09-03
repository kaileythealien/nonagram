class_name GetPageController extends Node

var all_pages_array: PackedStringArray
var all_pages_text: String

func _ready():
	ChangeBook("A")

func ChangeBook(id: String):
	var file = FileAccess.open("res://Scripts/BOOK_" + id + ".txt", FileAccess.READ)
	all_pages_text = file.get_as_text()
	all_pages_array = all_pages_text.split("\n")

func GetPathFromID(id: int = 0) -> String:
	return all_pages_array[id].split(" = ")[0]

func GetPathByDefinition(id: String = "1") -> Array:
	print(">" + id + "<")
	var def_at: int = all_pages_text.find(">" + id + "<")
	print(def_at)
	var def_at_line: int = all_pages_text.count("\n",0,def_at)
	var path_to_page: String = all_pages_array[def_at_line].split(" = ")[0]
	return [path_to_page,def_at_line]
