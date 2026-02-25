extends Control

@export_enum("house", "community", "farm") var type #0-house / 1-community / 2-farm
@export var plot_spot : String
@export var building : String

var reference_dictionary : Dictionary 
var wood = 0
var stone = 0
var labor = 0
var water = 0
var is_built

func _ready() -> void:
	set_up_card(type, plot_spot, building)

func set_up_card(dict_type, build_plot, item_building) -> void:
	$VBoxContainer/ScrollContainer.scroll_vertical = 0
	$VBoxContainer/ScrollContainer2.scroll_vertical = 0
	type = dict_type
	plot_spot = build_plot
	building = item_building
	match type:
		0: # house
			reference_dictionary = BuySheet.ShelterDwellings.duplicate(true)
			building_set_up_text()
		1: #community
			reference_dictionary = BuySheet.CommunityGathering.duplicate(true)
			building_set_up_text()
		2: # farm
			reference_dictionary = BuySheet.FarmingFields.duplicate(true)
			farm_set_up_text()
		3: # crops
			reference_dictionary = BuySheet.CropList.duplicate(true)
			farm_set_up_text()
			$queued_label.text = "PLANTING TONIGHT"
	#print(reference_dictionary)
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
	if type < 3:
		rubble_prices()
		check_built()
		check_budget()
	if type == 3:
		check_planted()
		check_budget()

func farm_set_up_text() -> void:
	%name.text = reference_dictionary[building]["name"]
	%about.text = reference_dictionary[building]["about"]
	
	var atlas = AtlasTexture.new()
	atlas.atlas = BuySheet.FarmingFields["rubble"]["source"]
	# 1. x frame * width / 2. y frame * hieght / 3. width / 4. height
	
	if type == 3 && building == "none":
		var plot_build = BuySheet.BuildingInventory[plot_spot]["built"]
		atlas.region = Rect2((BuySheet.FarmingFields[plot_build]["image"][0]*BuySheet.FarmingFields[plot_build]["image"][2]), (BuySheet.FarmingFields[plot_build]["image"][1]*BuySheet.FarmingFields[plot_build]["image"][3]), (BuySheet.FarmingFields[plot_build]["image"][2]), (BuySheet.FarmingFields[plot_build]["image"][3]))
	else:
		atlas.region = Rect2((reference_dictionary[building]["image"][0]*reference_dictionary[building]["image"][2]), (reference_dictionary[building]["image"][1]*reference_dictionary[building]["image"][3]), (reference_dictionary[building]["image"][2]), (reference_dictionary[building]["image"][3]))
	%image.texture = atlas
	
	wood = 0
	stone = 0
	var multiplier = 1
	
	if type == 2: #fields themselves
		match building:
			"medium_field": multiplier = 2
			"large_field": multiplier = 3
		match BuySheet.BuildingInventory[plot_spot]["built"]:
			"small_field": 
				labor = reference_dictionary[building]["labor"] -20
				water = reference_dictionary[building]["water"] -20
			"medium_field":
				labor = reference_dictionary[building]["labor"] -40
				water = reference_dictionary[building]["water"] -40
			"large_field":
				labor = reference_dictionary[building]["labor"]
				water = reference_dictionary[building]["water"]
		
		if labor < 20:
			labor = 20
		if water < 20:
			water = 20
		
		%costs.text = "Cost:\n   Build Water: " + str(water) + "\n   Build Labor: " + str(labor) + "\n   Daily Labor: " + str(BuySheet.CropList["none"]["labor_daily"] * multiplier)+ "\n   Daily Water: " + str(BuySheet.CropList["none"]["water"] * multiplier)
	
	elif type == 3: #crops
		match BuySheet.BuildingInventory[plot_spot]["built"]:
			"medium_field": multiplier = 2
			"large_field": multiplier = 3
		labor = reference_dictionary[building]["labor_plant"] * multiplier
		water = reference_dictionary[building]["water"] * multiplier
		
		%costs.text = "Cost:\n   Daily Water: " + str(water) + "\n   Build Labor: " + str(labor) + "\n   Daily Labor: " + str(BuySheet.CropList[building]["labor_daily"] * multiplier)
		%buy_button.text = "plant this"

func building_set_up_text() -> void:
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
	if Globals.budget_check(BuySheet.ResourceInventory["wood"], wood) && Globals.budget_check(BuySheet.ResourceInventory["stone"], stone) && Globals.budget_check(BuySheet.ResourceInventory["labor"], labor) && Globals.budget_check(BuySheet.ResourceInventory["water"], water):
		#print(building + " - can afford")
		if !is_built:
			%buy_button.disabled = false
			var tool_tip = "Click to build this."
			if type == 3:
				tool_tip = "Click to plant this."
			%buy_button.tooltip_text = tool_tip
	
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
	elif BuySheet.BuildingInventory[plot_spot]["built"] != "rubble" && building != "rubble" && type < 2:
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You have to demolish the building already here to build this."
		is_built = true
	else:
		is_built = false
		%buy_button.disabled = false
		%buy_button.tooltip_text = "Click to build this."

func check_planted() -> void:
	if BuySheet.BuildingInventory[plot_spot]["worked_today"]:
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You're already planting something here today."
		is_built = true
	elif BuySheet.BuildingInventory[plot_spot]["crop_planted"] == building:
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You have already this planted here"
		is_built = true
	elif BuySheet.BuildingInventory[plot_spot]["crop_planted"] != "none" && building != "none":
		%buy_button.disabled = true
		%buy_button.tooltip_text = "You have to clear out the field to plant something new."
		is_built = true
	else:
		is_built = false
		%buy_button.disabled = false
		%buy_button.tooltip_text = "Click to plant this."

func rubble_prices() -> void:
	if building == "rubble" && type < 2:
	#print(BuySheet.BuildingInventory[plot_spot])
		wood = roundi(reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["wood"] * 0.5)
		stone = roundi(reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["stone"] * 0.5)
		%costs.text = "Cost:\n      Wood: +" + str(wood) + "\n      Stone: +" + str(stone) + "\n      Labor: " + str(labor)


func _on_buy_button_pressed() -> void:
	if type < 3:
		if type < 2:
			Globals.building_purchase([building, wood, stone, labor])
		if type > 1:
			Globals.farming_costs([water, labor])
		
		BuySheet.BuildingInventory[plot_spot].set("queued", building)
		%buy_button.tooltip_text = "You built this building."
	
	if type == 3:
		Globals.farming_costs([water, labor])
		BuySheet.BuildingInventory[plot_spot].set("crop_planted", building)
		BuySheet.BuildingInventory[plot_spot].set("crop_level", 0)
	
	BuySheet.BuildingInventory[plot_spot].set("worked_today", true)
	Globals.interact_with("GLOBAL_PURCHASE", str(type), plot_spot)
	%buy_button.disabled = true
	$queued_label.visible = true
	reload()
