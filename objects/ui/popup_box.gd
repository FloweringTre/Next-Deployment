extends Control

signal answer

func _ready() -> void:
	$".".visible = false


func open_popup(yes_no_type: bool, header: String, message: String) -> void:
	%moveButton.visible = !yes_no_type
	%y_nBox.visible = yes_no_type
	%title.text = header
	%text.text = message
	$".".visible = true
	print(header)

func close() -> void:
	%title.text = ""
	%text.text = ""
	$".".visible = false

func _move_on_button_pressed() -> void:
	answer.emit("continue")
	close()

func _on_no_button_pressed() -> void:
	answer.emit("no")
	close()

func _on_yes_button_pressed() -> void:
	answer.emit("yes")
	close()
