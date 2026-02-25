extends Control

func _ready() -> void:
	$".".visible = false

func set_up() -> void:
	$".".visible = true
	%name.text = "Lt. " + Globals.PlayerData["name"] + " - CT-" + Globals.PlayerData["number"]
	%gar.text = "GAR Repuation: " + str(Globals.PlayerData["g_rep"])
	%community.text = "Local Repuation: " + str(Globals.PlayerData["c_rep"])
	display("", "")
	Globals.interact_with("GLOBAL_DIALOG", "popup_box", "start")

func display(header: String, message: String) -> void:
	%title.text = header
	%text.text = message

func _on_list_button_pressed() -> void:
	var temp = ""
	var list = ""
	for item in Globals.Checklist:
		#print(item)
		temp = " " + str(Globals.Checklist[item]["has"]) + "/" + str(Globals.Checklist[item]["need"]) + " - " + str(Globals.Checklist[item]["name"] + "\n")
		list += temp
		temp = ""
	
	display("GAR DEPLOYMENT CHECKLIST", list)

func _on_costs_button_pressed() -> void:
	var list = "These values will be added/removed to your resources at the start at each day. \n\n"
	list += "  Stone: " + str(BuySheet.DailyCosts["stone"]) + "\n"
	list += "  Wood: " + str(BuySheet.DailyCosts["wood"]) + "\n"
	list += "  Max Labor: " + str(BuySheet.DailyCosts["labor"]) + "\n"
	list += "  Water: " + str(BuySheet.DailyCosts["water"]) + "\n"
	list += "  Food: " + str(BuySheet.DailyCosts["food"]) + "\n"
	
	display("Daily Resource Costs", list)

func _on_wants_button_pressed() -> void:
	var list = "This is what the community wants. \n\n"
	var temp = ""
	for item in Globals.Checklist:
		#print(item)
		temp = " " + str(Globals.Checklist[item]["c_want"][1]) + "/" + str(Globals.Checklist[item]["c_want"][2]) + " - " + str(Globals.Checklist[item]["name"] + "\n")
		list += temp
		temp = ""
	
	display("Community Wants", list)

func _on_away_pressed() -> void:
	$".".visible = false
	Globals.interact_with("GLOBAL_DIALOG", "popup_box", "end")
