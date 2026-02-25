extends Control

func _ready() -> void:
	$".".visible = false


func open(header: String, message: String) -> void:
	%title.text = header
	%text.text = message
	$".".visible = true
	Globals.interact_with("GLOBAL_DIALOG", "popup_box", "start")

func _on_button_pressed() -> void:
	%title.text = ""
	%text.text = ""
	$".".visible = false
	Globals.interact_with("GLOBAL_DIALOG", "popup_box", "end")
