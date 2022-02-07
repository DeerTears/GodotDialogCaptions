extends Node2D

## CaptionedAudio2D and CaptionDisplay have default properties.

func _ready():
	$CaptionedAudio2D.play_captioned("dialog1")
