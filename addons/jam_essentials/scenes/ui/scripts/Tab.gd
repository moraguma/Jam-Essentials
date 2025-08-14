extends Panel
class_name Tab


signal clicked


var translation_code: String 


@onready var selected_panel: StyleBox = theme.get_stylebox("selected_tab", "Tab")
@onready var deselected_panel: StyleBox = theme.get_stylebox("deselected_tab", "Tab")

@onready var icon: TextureRect = $HBoxContainer/Icon
@onready var tab_label: Label = $HBoxContainer/Name


## Names and sets icon
func initialize(tab_translation_code: String, icon_texture: Texture2D) -> void:
	add_to_group("localizable")
	
	translation_code = tab_translation_code
	icon.texture = icon_texture
	
	localize()


func localize() -> void:
	tab_label.text = tr(translation_code)


## Called when this tab is selected
func select() -> void:
	tab_label.show()
	add_theme_stylebox_override("panel", selected_panel)


## Called when this tab is deselected
func deselect() -> void:
	tab_label.hide()
	add_theme_stylebox_override("panel", deselected_panel)


func pressed() -> void:
	clicked.emit()
