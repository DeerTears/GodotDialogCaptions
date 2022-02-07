extends Button

func _ready() -> void:
	connect("pressed", get_tree(),"change_scene", ["res://menus/CaptionOptionsMenu.tscn"])
