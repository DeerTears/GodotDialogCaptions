## Displays translated captions from CaptionAutoload on a regular label.
extends Control

const TRANSPARENT := Color(1.0, 1.0, 1.0, 0.0)
const OPAQUE := Color(1.0, 1.0, 1.0, 1.0)

## Font height in pixels. You can use this, or directly change the font resources instead.
export (int, 10, 240) var font_height: int = 30 setget set_font_height, get_font_height
# At least 2.6% to 3% of your screen size. 1080p is 28 to 32 pixels minimum.

## How fast in seconds the display fades in and out between captions.
export (float, 0.0, 3.0, 0.01) var fade_speed_between_captions: float = 0.25

## Determines if the text is revealed slowly or shown all at once.
export var is_dialog_instant: bool = false

## If not instant, the effect is completed early to allow the reader to absorb the line fully.
export var show_full_line_for_x_seconds: float = 1.0

## Set by the "display" signal on CaptionAutoload. Fit to the length of the sound clip. Do not adjust.
var _line_duration: float = 5.0

## Changes the caption background color. Optionally, ignore this and directly change the stylebox resource instead.
export var block_background_color: Color = Color(0.0, 0.0, 0.0, 0.6) setget set_block_background_color, get_block_background_color

var block_background := preload("res://styles/BlockBackground.tres")

var font_normal := preload("res://styles/fonts/verdana/verdana-normal.tres")
var font_bold := preload("res://styles/fonts/verdana/verdana-bold.tres")
# Italics are not accessible for dyslexic gamers. Use bold, underline, or a larger font size instead.

onready var caption_label: Label = $SafeArea/MarginContainer/Label

# Fades in and out the caption display.
onready var tween: Tween = $Tween


func _ready() -> void:
	modulate = TRANSPARENT
	
	# CaptionAutoload must be ready before we can connect to it.
	if not CaptionAutoload.is_inside_tree():
		yield(CaptionAutoload, "ready")
	CaptionAutoload.connect("display", self, "_on_CaptionAutoload_display")
	CaptionAutoload.connect("hide", self, "_on_CaptionAutoload_hide")

	# todo: do this in a setter instead
	block_background.bg_color = block_background_color


func set_font_height(pixels: int) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	font_height = pixels
	font_normal.size = pixels
	font_bold.size = pixels


## This value can be changed outside of CaptionDisplay by the resource itself.
func get_font_height() -> int:
	font_height = font_normal.size
	if font_normal.size != font_bold.size:
		push_warning(
			"CaptionDisplay returned font height %s for normal. Bold has unique font size %s" %
			[font_normal.size, font_bold.size]
		)
	return font_height


func set_block_background_color(color: Color) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	block_background_color = color
	block_background.bg_color = color


## This value can be changed outside of CaptionDisplay by the resource itself.
func get_block_background_color() -> Color:
	block_background_color = block_background.bg_color 
	return block_background_color


func _on_CaptionAutoload_display(text: String, duration: float) -> void:
	_line_duration = duration

	if fade_speed_between_captions == 0.0:
		modulate = OPAQUE
	else:
		tween.interpolate_property(
			self, "modulate",
			modulate, OPAQUE,
			fade_speed_between_captions,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)

	if not is_dialog_instant:
		var full_line_duration = _line_duration - show_full_line_for_x_seconds

		tween.interpolate_property(
			caption_label, "percent_visible",
			0.0, 1.0,
			full_line_duration if full_line_duration >= 0.0 else 0.0,
			Tween.TRANS_LINEAR, Tween.EASE_IN
		)
	tween.start()

	caption_label.text = text


func _on_CaptionAutoload_hide() -> void:
	if fade_speed_between_captions == 0.0:
		modulate = TRANSPARENT
	else:
		tween.interpolate_property(
			self, "modulate",
			modulate, TRANSPARENT,
			fade_speed_between_captions,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		tween.start()
