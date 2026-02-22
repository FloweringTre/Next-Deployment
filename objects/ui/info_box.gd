extends Control

@export_enum("house", "community", "farm") var type #0-house / 1-community / 2-farm
@export var plot_spot : String
@export var building : String

var reference_dictionary : Dictionary 
var wood
var stone
var labor
var is_built

func _ready() -> void:
	set_up_card(type, plot_spot, building)

func set_up_card(dict_type, build_plot, item_building) -> void:
	type = dict_type
	plot_spot = build_plot
	building = item_building
	match type:
		0: # house
			reference_dictionary = BuySheet.ShelterDwellings.duplicate(true)
		1: #community
			reference_dictionary = BuySheet.CommunityGathering.duplicate(true)
		2: # farm
			reference_dictionary = BuySheet.FarmingFields.duplicate(true)
	#print(reference_dictionary)
	set_up_text()
	reload()
	Globals.object_interaction.connect(_on_global_interaction)

func _on_global_interaction(reciever, sender, message):
	match reciever:
		"GLOBAL_PURCHASE":
			if sender == str(type):
				reload()
		"GLOBAL_ALERT":
			match message:
				"new_day":
					reload()

func reload() -> void: 
	#so we can rerun these values whenever we want without calling the full _ready func
	rubble_prices()
	check_built()
	check_budget()


func set_up_text() -> void:
	wood = reference_dictionary[building]["wood"]
	stone = reference_dictionary[building]["stone"]
	labor = reference_dictionary[building]["labor"]
	
	%name.text = reference_dictionary[building]["name"]
	%about.text = reference_dictionary[building]["about"]
	
	var atlas = AtlasTexture.new()
	atlas.atlas = reference_dictionary[building]["source"]
	# 1. x frame * width / 2. y frame * hieght / 3. width / 4. height
	atlas.region = Rect2((reference_dictionary[building]["image"][0]*reference_dictionary[building]["image"][2]), (reference_dictionary[building]["image"][1]*reference_dictionary[building]["image"][3]), (reference_dictionary[building]["image"][2]), (reference_dictionary[building]["image"][3]))
	%image.texture = atlas
	
	%costs.text = "Cost:\n      Wood: " + str(wood) + "\n      Stone: " + str(stone) + "\n      Labor: " + str(labor)

func check_budget() -> void:
	if Globals.budget_check(BuySheet.ResourceInventory["wood"], wood) && Globals.budget_check(BuySheet.ResourceInventory["stone"], stone) && Globals.budget_check(BuySheet.ResourceInventory["labor"], labor):
		#print(building + " - can afford")
		if !is_built:
			%buy_button.disabled = false
			%buy_button.tooltip_text = "Click to build this."
	
	else:
		#print(building + "- CANT afford")
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You can't afford this."

func check_built() -> void:
	if BuySheet.BuildingInventory[plot_spot]["worked_today"]:
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You're already building something here today."
		is_built = true
	elif BuySheet.BuildingInventory[plot_spot]["built"] == building:
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You have already built this building here."
		is_built = true
	elif BuySheet.BuildingInventory[plot_spot]["built"] != "rubble" && building != "rubble":
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You have to demolish the building already here to build this."
		is_built = true
	else:
		is_built = false
		%buy_button.disabled = false
		%buy_button.tooltip_text = "Click to build this."

func rubble_prices() -> void:
	if building == "rubble":
	#print(BuySheet.BuildingInventory[plot_spot])
		wood = roundi(reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["wood"] * 0.5)
		stone = roundi(reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["stone"] * 0.5)
		%costs.text = "Cost:\n      Wood: +" + str(wood) + "\n      Stone: +" + str(stone) + "\n      Labor: " + str(labor)


func _on_buy_button_pressed() -> void:
	Globals.purchase([building, wood, stone, labor])
	BuySheet.BuildingInventory[plot_spot].set("queued", building)
	BuySheet.BuildingInventory[plot_spot].set("worked_today", true)
	Globals.interact_with("GLOBAL_PURCHASE", str(type), plot_spot)
	%buy_button.disabled = true
	%buy_button.tooltip_text = "You built this building."
	$queued_label.visible = true
	reload()
