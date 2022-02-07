## An autoload bus that emits caption signals. Called by CaptionedAudio nodes.
extends Node
## You should configure this alongside your 

# TODO: Rename these signals across CaptionAutoload and CaptionDisplay to be past tense verbs in relation to what they do.

## Provides text for CaptionDisplay.tscn to show.
signal display(translated_caption, duration_in_seconds)

## Tells the CaptionDisplay.tscn node to hide.
signal hide

## Removes the "_..." suffix from locale if true.
var can_use_regional_dialects: bool = false

## 
var audio_folder_name: String = "voice"

## Unused, todo. Planned to keep a pool of current lines that should be shown.
var visible_lines := []

## Takes a key from any audio source, sends it through TranslationServer, and emits it.

## adds a key to the list of currently visible liens
func show_line(incoming_key: String, duration: float, speaker_name: String) -> void:
	# Look for dialog.csv for translation strings. BBCode tags are allowed.
	if speaker_name == "":
		emit_signal("display", tr(incoming_key), duration)
	else:
		emit_signal("display", "%s: %s" % [speaker_name, tr(incoming_key)], duration)
	visible_lines.append(incoming_key)


## removes a key to the list of currently visible lines
func hide_line(incoming_key: String) -> void:
	visible_lines.erase(incoming_key)
	emit_signal("hide")


# todo: have the setter emit the signal using this rather than when show_line or hide_line is called.
func set_visible_lines(_visible_lines: Array) -> void:
	visible_lines = _visible_lines
	emit_signal("display", get_highest_priority_line())


# todo: asset priorities before making this work. a priority numbering system? a channel system?
func get_highest_priority_line() -> String:
	var returned_line: String = ""
	for line in visible_lines:
		returned_line = line
	return returned_line


func get_visible_lines() -> Array:
	return visible_lines
