## An audio player that updates its stream to fit the translation key.

extends AudioStreamPlayer3D

class_name CaptionedAudio3D

const LINE_NOT_FOUND_DURATION := 6.0

## Leave blank if none.
export var speaker_name := ""
## 
export var audio_file_extension := ".ogg"

onready var locale = "en"

func _ready():
	update_locale()


func update_locale() -> void:
	locale = TranslationServer.get_locale()
	if not CaptionAutoload.can_use_regional_dialects:
		locale = locale.split("_")[0]

func play_captioned(key: String) -> void:
	set_stream(load("res://%s/%s/%s%s" % [CaptionAutoload.audio_folder_name, locale, key, audio_file_extension]))
	
	if stream == null:
		_play_failed_caption(key)
	else:
		play()
		CaptionAutoload.show_line(key, stream.get_length(), speaker_name)
		yield(self, "finished")
		CaptionAutoload.hide_line(key)

func _play_failed_caption(key: String) -> void:
	CaptionAutoload.show_line(key, LINE_NOT_FOUND_DURATION, "")
	yield(get_tree().create_timer(LINE_NOT_FOUND_DURATION), "timeout")
	CaptionAutoload.hide_line(key)
