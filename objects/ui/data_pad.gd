extends Control

var open_tab = [-1, -1]

func _ready() -> void:
	$".".visible = false
	Globals.object_interaction.connect(_on_global_interaction)

func _on_global_interaction(reciever, sender, message):
	match reciever:
		"GLOBAL_DIALOG":
			if sender == "datapad":
				pass
			elif message == "start":
				$".".visible = false
			elif message == "end":
				$".".visible = false


func set_up() -> void:
	$".".visible = true
	%name.text = "Lt. " + Globals.PlayerData["name"] + " - CT-" + Globals.PlayerData["number"]
	%gar.text = "GAR Repuation: " + str(Globals.PlayerData["g_rep"]) + "/" + str(Globals.Checklist.size()*10)
	%community.text = "Local Repuation: " + str(Globals.PlayerData["c_rep"]) + "/" + str(Globals.Checklist.size()*10)
	display("", "")
	Globals.interact_with("GLOBAL_DIALOG", "datapad", "start")


func display(header: String, message: String) -> void:
	%title.text = header
	%text.text = message

func _on_away_pressed() -> void:
	$".".visible = false
	Globals.interact_with("GLOBAL_DIALOG", "datapad", "end")


func tab_list() -> void:
	var temp = ""
	var list = ""
	for item in Globals.Checklist:
		#print(item)
		temp = " " + str(Globals.Checklist[item]["has"]) + "/" + str(Globals.Checklist[item]["need"]) + " - " + str(Globals.Checklist[item]["name"] + "\n")
		list += temp
		temp = ""
	
	display("GAR DEPLOYMENT CHECKLIST", list)

func tab_costs() -> void:
	var list = "These values will be added/removed to your resources at the start at each day. \n\n"
	list += "  Stone: " + str(BuySheet.DailyCosts["stone"]) + "\n"
	list += "  Wood: " + str(BuySheet.DailyCosts["wood"]) + "\n"
	list += "  Max Labor: " + str(BuySheet.DailyCosts["labor"]) + "\n"
	list += "  Water: " + str(BuySheet.DailyCosts["water"]) + "\n"
	list += "  Food: " + str(BuySheet.DailyCosts["food"]) + "\n"
	
	display("Daily Resource Costs", list)

func tab_wants() -> void:
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
			Globals.game_ending_calculation()
			#$Panel/PopupPanel.visible = true
			#$Panel/PopupPanel/PopupBox.open_popup(false, "Deployment ended.", "Congrats. You have completed your mission.")

func _on_deploy_button_pressed() -> void:
	$Panel/PopupPanel.visible = true
	$Panel/PopupPanel/PopupBox.open_popup(true, "End Deployment?", "Are you sure you have completed all mission objectives for this deployment and are ready to return to Command?")


func swap_tabs(row, tab) -> void:
	if open_tab == [row, tab]:
		display("", "")
		open_tab = [-1, -1]
	else:
		open_tab = [row, tab]
		match open_tab:
			[1,0]: #home
				display("Home Screen", "text")
			[1,1]: #gar checklist
				tab_list()
			[1,2]: #costs
				tab_costs()
			[1,3]: #com want
				tab_wants()
			
			[0,0]: #tab [blank]
				display("Header", "tab 1")
			[0,1]: #tab [blank]
				display("Header", "tab 2")
			[0,2]: #tab [blank]
				display("Header", "tab 3")
			[0,3]: #tab [blank]
				display("Header", "tab 4")

func _on_tab_bar_tab_clicked(tab: int) -> void:
	#the tab with home/checklist/costs/com wants
	%tabs.move_child(%row0, 0)
	if %row0.current_tab > -1:
		%row0.current_tab = -1
	%row1.current_tab = tab
	swap_tabs(1, tab)

func _on_tab_bar_2_tab_clicked(tab: int) -> void:
	#the tab with empty tabs
	%tabs.move_child(%row1, 0)
	if %row1.current_tab > -1:
		%row1.current_tab = -1
	%row0.current_tab = tab
	swap_tabs(0, tab)
