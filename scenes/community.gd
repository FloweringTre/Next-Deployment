extends Node2D

func _ready() -> void:
	Globals.object_interaction.connect(_on_global_interaction)
	resource_update()

func _on_global_interaction(reciever, sender, message):
	match reciever:
		"GLOBAL_PURCHASE":
			resource_update()
		
		"GLOBAL_ALERT":
			match message:
				"Not Enough Resources":
					%alert_label.text = "Not enough resources to build"
					$Timer.start(3)
				"new_day":
					resource_update()

func resource_update() -> void:
	%wood.text = str(BuySheet.ResourceInventory["wood"])
	%stone.text = str(BuySheet.ResourceInventory["stone"])
	%labor.text = str(BuySheet.ResourceInventory["labor"])
	%day.text = str(Globals.day_count)


func _on_timer_timeout() -> void:
	%alert_label.text = ""


func _on_button_pressed() -> void:
	Globals.interact_with("global_new_day", "new_day_button", "new_day")
	#print("newdaybuttonpressed")
