extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$"Main Menu/Main Menu/VBoxContainer/Start".grab_focus()
