## An audio player that updates its stream to fit the translation key, and
extends AudioStreamPlayer

class_name CaptionedAudio

const DEBUG_DURATION := 6.0

export var speaker_name := ""

onready var locale = "en"

func _ready():
	update_locale()

func update_locale() -> void:
	locale = TranslationServer.get_locale()
	if not CaptionAutoload.can_use_regional_dialects:
		locale = locale.split("_")[0]


func play_captioned(key: String) -> void:
	# Failing to load the file will automatically push an error.
	set_stream(load("res://voice/%s/%s.ogg" % [locale, key]))
	# Accounting for if this happens, make sure the caption times out on its own regardless.
	if stream == null:
		CaptionAutoload.show_line(key, DEBUG_DURATION, "")
		yield(get_tree().create_timer(DEBUG_DURATION), "timeout")
		CaptionAutoload.hide_line(key)
	else:
		play()
		CaptionAutoload.show_line(key, stream.get_length(), speaker_name)
		yield(self, "finished")
		CaptionAutoload.hide_line(key)
