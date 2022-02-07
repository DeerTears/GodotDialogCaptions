## An example caption options menu.
extends Control

onready var block_opacity: HSlider = $VBoxContainer/HBoxContainer/Controls/BlockOpacity
onready var text_size: SpinBox = $VBoxContainer/HBoxContainer/Controls/TextSize
onready var text_outline: SpinBox = $VBoxContainer/HBoxContainer/Controls/TextOutline
onready var locale: OptionButton = $VBoxContainer/HBoxContainer/Controls/Locale

var block_background := preload("res://styles/BlockBackground.tres")

var font_normal := preload("res://styles/fonts/verdana/verdana-normal.tres")
var font_bold := preload("res://styles/fonts/verdana/verdana-bold.tres")


func _ready() -> void:
	block_opacity.connect("value_changed", self, "_on_block_opacity_changed")
	text_size.connect("value_changed", self, "_on_text_size_changed")
	text_outline.connect("value_changed", self, "_on_text_outline_changed")
	locale.connect("item_selected", self, "_on_locale_item_selected")

	for locale_string in TranslationServer.get_loaded_locales():
		locale.add_item(locale_string)

	font_normal.size = text_size.value

	$Back.connect("pressed", get_tree(), "change_scene", ["res://demo/levels/DemonstrationLevel.tscn"])


func _on_text_outline_changed(value: float):
	font_normal.outline_size = int(value)
	font_bold.outline_size = int(value)


func _on_text_size_changed(value: float):
	font_normal.size = int(value)
	font_bold.size = int(value)


func _on_block_opacity_changed(value: float):
	block_background.bg_color.a = value


func _on_locale_item_selected(index: int):
	TranslationServer.set_locale(locale.get_item_text(index))
