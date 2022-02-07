extends Area2D

func talk() -> void:
	$CaptionedAudio2D.play_captioned("dialog1")
	yield(get_tree().create_timer(3.0), "timeout")
	$CaptionedAudio2D.play_captioned("dialog2")
