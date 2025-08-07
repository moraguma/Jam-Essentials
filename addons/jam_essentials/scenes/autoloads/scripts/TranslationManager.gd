extends Node
class_name TranslationManager


## Conects language code to the path to its translation json
@export var language_to_translation: Dictionary = {}


var current_language = ""
var translation_dict = null


## Sets the language to the specified code. This will set the translation dict
## as the json specified for that language code in language_to_translation
func set_language(language_code: String) -> void:
	if not language_code in language_to_translation:
		push_warning("Tried to load a non configured language %s" % [language_code])
		return
	
	var json_string = FileAccess.get_file_as_string(language_to_translation[language_code])
	if json_string == "":
		push_warning("Error on loading JSON for language_code %s: %s" % [language_code, FileAccess.get_open_error()])
		return
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_warning("Error on parsing JSON for language_code %s: %s" % [language_code, json.get_error_message()])
		return
	
	current_language = language_code
	translation_dict = json.data


## Returns the translation for the given code. Will search for this code in the 
## currently loaded translation dict
func get_translation(code: String) -> String:
	if translation_dict == null: # If doesn't have translation, doesn't translate
		return code
	
	if not code in translation_dict:
		push_warning("Tried fetching non existent translation for %s in language %s" % [code, current_language])
		return "TRANSLATION_NOT_FOUND"
	
	return translation_dict[code]
