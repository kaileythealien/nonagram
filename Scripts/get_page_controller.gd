class_name GetPageController extends Node

var all_pages_array: PackedStringArray
var all_pages_array_definitions_only: PackedStringArray
var all_pages_text: String

func _ready():
	ChangeBook("A")

func ChangeBook(id: String):
	var file: FileAccess = FileAccess.open("res://Scripts/BOOK_" + id + ".txt", FileAccess.READ)
	all_pages_text = file.get_as_text()
	var all_pages_array_temp: PackedStringArray = all_pages_text.split("\n")
	
	#CREATE THE ARRAYS
	
	for page_line in all_pages_array_temp.size():
		var the_text_in_question: String = all_pages_array_temp[page_line-1]
		
		if the_text_in_question.begins_with("!"):
			all_pages_array_definitions_only.append(the_text_in_question)
			continue
		elif the_text_in_question.begins_with("#") or the_text_in_question == "":
			continue
		
		all_pages_array.append(the_text_in_question)

#TODO: MAKE IT SO IF YOU GO ABOVE PAGE NUM IT RETURNS TO LAST PAGE

func GetPathFromID(id: int = 0) -> String:
	if id < 0 or id > all_pages_array.size()+1:
		#temporary solution
		return all_pages_array[1].split(" = ")[0]
	return all_pages_array[id].split(" = ")[0]

func GetPathByDefinition(id: String = "1") -> Array:
	var def_at: int
	var path_to_page: String
	
	id = id.replace(" ","")
	
	for index in all_pages_array_definitions_only.size():
		if all_pages_array_definitions_only[index-1].findn(">" + id + "<") != -1:
			path_to_page = all_pages_array_definitions_only[index-1].split(" = ")[0].right(-1)
			return [path_to_page,1000+index]
	for index in all_pages_array.size():
		if all_pages_array[index-1].findn(">" + id + "<") != -1:
			def_at = index-1
			path_to_page = all_pages_array[index-1].split(" = ")[0]
			return [path_to_page,def_at]
	
	push_warning("UNKNOWN DEFINITION: \"" + id + "\"")
	return ["res://Pages/BookA/__error.tscn",0]

func getIDFromPath(path: String) -> int:
	for index in all_pages_array.size():
		if all_pages_array[index-1].findn(path) != -1:
			return index-1
	return -1
