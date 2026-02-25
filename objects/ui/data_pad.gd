extends Control

func _ready() -> void:
	$".".visible = false

func set_up() -> void:
	$".".visible = true
	%name.text = "Lt. " + Globals.PlayerData["name"] + " - CT-" + Globals.PlayerData["number"]
	%gar.text = "GAR Repuation: " + str(Globals.PlayerData["g_rep"])
	%community.text = "Local Repuation: " + str(Globals.PlayerData["c_rep"])
	display("", "")
	Globals.interact_with("GLOBAL_DIALOG", "datapad", "start")

func tab_swap(tab : String) -> void:
	match tab:
		"list":
			$Panel/Panel/VBoxContainer/tab_list/CostsButton.button_pressed = false
			$Panel/Panel/VBoxContainer/tab_list/WantsButton.button_pressed = false
		"cost":
			$Panel/Panel/VBoxContainer/tab_list/ListButton.button_pressed = false
			$Panel/Panel/VBoxContainer/tab_list/WantsButton.button_pressed = false
		"want":
			$Panel/Panel/VBoxContainer/tab_list/ListButton.button_pressed = false
			$Panel/Panel/VBoxContainer/tab_list/CostsButton.button_pressed = false

func display(header: String, message: String) -> void:
	%title.text = header
	%text.text = message

func _on_away_pressed() -> void:
	$".".visible = false
	Globals.interact_with("GLOBAL_DIALOG", "datapad", "end")


func _on_list_button_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		display("", "")
		
	else:
		tab_swap("list")
		var temp = ""
		var list = ""
		for item in Globals.Checklist:
			#print(item)
			temp = " " + str(Globals.Checklist[item]["has"]) + "/" + str(Globals.Checklist[item]["need"]) + " - " + str(Globals.Checklist[item]["name"] + "\n")
			list += temp
			temp = ""
		
		display("GAR DEPLOYMENT CHECKLIST", list)

func _on_costs_button_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		display("", "")
	else:
		tab_swap("cost")
		var list = "These values will be added/removed to your resources at the start at each day. \n\n"
		list += "  Stone: " + str(BuySheet.DailyCosts["stone"]) + "\n"
		list += "  Wood: " + str(BuySheet.DailyCosts["wood"]) + "\n"
		list += "  Max Labor: " + str(BuySheet.DailyCosts["labor"]) + "\n"
		list += "  Water: " + str(BuySheet.DailyCosts["water"]) + "\n"
		list += "  Food: " + str(BuySheet.DailyCosts["food"]) + "\n"
		
		display("Daily Resource Costs", list)

func _on_wants_button_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		display("", "")
	else:
		tab_swap("want")
		var list = "This is what the community wants. \n\n"
		var temp = ""
		for item in Globals.Checklist:
			#print(item)
			temp = " " + str(Globals.Checklist[item]["c_want"][1]) + "/" + str(Globals.Checklist[item]["c_want"][2]) + " - " + str(Globals.Checklist[item]["name"] + "\n")
			list += temp
			temp = ""
		
		display("Community Wants", list)


func _on_popup_box_answer(answer : String) -> void:
	$Panel/PopupPanel.visible = false
	match answer:
		"continue":
			pass
		"no":
			pass
		"yes":
			await Engine.get_main_loop().process_frame
			$Panel/PopupPanel.visible = true
			$Panel/PopupPanel/PopupBox.open_popup(false, "Deployment ended.", "Congrats. You have completed your mission.")


func _on_deploy_button_pressed() -> void:
	$Panel/PopupPanel.visible = true
	$Panel/PopupPanel/PopupBox.open_popup(true, "End Deployment?", "Are you sure you have completed all mission objectives for this deployment and are ready to return to Command?")
