extends Node2D

var mouse_pressed : bool = false
var old_location : Vector2
var new_location : Vector2
var menu_open : bool = false
var dialog_open : bool = false

func _ready() -> void:
	Globals.object_interaction.connect(_on_global_interaction)
	resource_update()

func _input(event: InputEvent) -> void:
	if event.is_action("test_key"):
		Dialogic.start("test_start")
	
	elif event is InputEventMouseButton and !menu_open and !dialog_open:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			%Camera2D.position = get_global_mouse_position()
			%Camera2D.zoom += Vector2(0.05, 0.05)
			if %Camera2D.zoom > Vector2(3.0, 3.0):
				%Camera2D.zoom = Vector2(3.0, 3.0)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			%Camera2D.zoom -= Vector2(0.05, 0.05)
			if %Camera2D.zoom < Vector2(1.0, 1.0):
				%Camera2D.zoom = Vector2(1.0, 1.0)
		
		elif event.button_index == MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed
			old_location = get_global_mouse_position()
			
			if !mouse_pressed:
				if %Camera2D.position.x > 1200:
					%Camera2D.position.x = 1200
				if %Camera2D.position.x < 0:
					%Camera2D.position.x = 0
				if %Camera2D.position.y > 720:
					%Camera2D.position.y = 720
				if %Camera2D.position.y < 0:
					%Camera2D.position.y = 0
	elif event is InputEventMouseMotion and mouse_pressed:
		new_location = get_global_mouse_position()
		%Camera2D.position -= (new_location - old_location)

func _on_global_interaction(reciever, sender, message):
	if sender == "Build_Menu" or reciever == "Build_Menu":
		menu_open = !menu_open
	
	match reciever:
		"Build_Menu":
			%Camera2D.position = message
			if %Camera2D.zoom == Vector2(1, 1):
				%Camera2D.zoom = Vector2(1.1, 1.1)
		
		"GLOBAL_PURCHASE":
			resource_update()
		"RESOURCE_UPDATE":
			resource_update()
		
		"GLOBAL_ALERT":
			match message:
				"Not Enough Resources":
					%alert_label.text = "Not enough resources to build"
					$Timer.start(3)
				"new_day":
					resource_update()
		
		"GLOBAL_DIALOG":
			if message == "start":
				dialog_open = true
				$".".modulate = Color(1, 1, 1, .5)
			if message == "end":
				dialog_open = false
				$".".modulate = Color(1, 1, 1, 1)
			$CanvasLayer.visible = !dialog_open
			
			if sender == "datapad":
				$CanvasLayer/HBoxContainer/DayButton.disabled = dialog_open
				$CanvasLayer/HBoxContainer/DatapadButton.disabled = dialog_open
				$CanvasLayer.visible = true


func resource_update() -> void:
	%wood.text = str(BuySheet.ResourceInventory["wood"])
	%stone.text = str(BuySheet.ResourceInventory["stone"])
	%labor.text = str(BuySheet.ResourceInventory["labor"])
	%water.text = str(BuySheet.ResourceInventory["water"])
	%food.text = str(BuySheet.ResourceInventory["food"])
	%day.text = str(Globals.day_count)


func _on_timer_timeout() -> void:
	%alert_label.text = ""


func _on_button_pressed() -> void:
	Globals.interact_with("global_new_day", "new_day_button", "new_day")
	#print("newdaybuttonpressed")


func _on_datapad_button_pressed() -> void:
	%DataPad.visible = true
	%DataPad.set_up()
