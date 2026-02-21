extends VBoxContainer

@export var plot_spot : String
@export var building : String
var wood
var stone
var labor
var is_built

func _ready() -> void:
	reload()
	Globals.object_interaction.connect(_on_global_interaction)

func _on_global_interaction(reciever, sender, message):
	match reciever:
		"GLOBAL_PURCHASE":
			reload()
		"GLOBAL_ALERT":
			match message:
				"new_day":
					reload()

func reload() -> void: 
	#so we can rerun these values whenever we want without calling the full _ready func
	set_up_text()
	check_built()
	check_budget()


func set_up_text() -> void:
	wood = BuySheet.ShelterDwellings[building]["wood"]
	stone = BuySheet.ShelterDwellings[building]["stone"]
	labor = BuySheet.ShelterDwellings[building]["labor"]
	
	%name.text = BuySheet.ShelterDwellings[building]["name"]
	%about.text = BuySheet.ShelterDwellings[building]["about"]
	%costs.text = "Cost:\n      Wood: " + str(wood) + "\n      Stone: " + str(stone) + "\n      Labor: " + str(labor)
	rubble_prices()

func check_budget() -> void:
	if Globals.budget_check(BuySheet.ResourceInventory["wood"], wood) && Globals.budget_check(BuySheet.ResourceInventory["stone"], stone) && Globals.budget_check(BuySheet.ResourceInventory["labor"], labor):
		print(building + " - can afford")
		if !is_built:
			%buy_button.disabled = false
			%buy_button.tooltip_text = ""
	
	else:
		print(building + "- CANT afford")
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You can't afford this."

func check_built() -> void:
	if BuySheet.BuildingInventory[plot_spot] == building:
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You have already built this building here."
		is_built = true
	else:
		is_built = false
		%buy_button.disabled = false
		%buy_button.tooltip_text = "Click to build this."

func rubble_prices() -> void:
	if building == "rubble":
		wood = roundi(BuySheet.ShelterDwellings[BuySheet.BuildingInventory[plot_spot]]["wood"] * 0.5)
		stone = roundi(BuySheet.ShelterDwellings[BuySheet.BuildingInventory[plot_spot]]["stone"] * 0.5)
		%costs.text = "Cost:\n      Wood: +" + str(wood) + "\n      Stone: +" + str(stone) + "\n      Labor: " + str(labor)


func _on_buy_button_pressed() -> void:
	Globals.purchase([building, wood, stone, labor])
	BuySheet.BuildingInventory.set(plot_spot, building)
	Globals.interact_with("GLOBAL_PURCHASE", "shelter_dwelling", plot_spot)
	%buy_button.disabled = true
	%buy_button.tooltip_text = "You built this building."
	reload()
