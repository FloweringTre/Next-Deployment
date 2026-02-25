extends Node

var PlayerData : Dictionary = {
	"name" = "",
	"number" = "",
	"gender" = 0, #0-He / 1-Her / 2-They
	"g_rep" = 100,
	"c_rep" = 50,
}

var Checklist : Dictionary = {
	"water" = {
		"name" = "Water Source",
		"tip" = "Build something to increase water resources daily.",
		"has" = 0,
		"need" = 1,
		"gar" = false,
		"c_want" = ["well", 0, 1], #name of value, has, want
		"com" = false,
	}, 
	"farm" = {
		"name" = "Food Stores",
		"tip" = "Build something to increase get the food stores up.",
		"has" = 0,
		"need" = 2,
		"gar" = false,
		"c_want" = ["grain", 0, 1], 
		"com" = false,
	},
	"house" = {
		"name" = "Shelter",
		"tip" = "Build places for the civilians to sleep in.",
		"has" = 0,
		"need" = 2,
		"gar" = false,
		"c_want" = ["brick_house", 0, 2], 
		"com" = false,
	}, 
	"community" = {
		"name" = "Community Space",
		"tip" = "Build something to let the civilians gather in town.",
		"has" = 0,
		"need" = 1,
		"gar" = false,
		"c_want" = ["covered_plaza", 0, 1], 
		"com" = false,
	}, 
	"days" = {
		"name" = "Days on Deployment",
		"tip" = "The GAR High Command needs you back sooner than later.",
		"has" = 0,
		"need" = 10,
		"gar" = false,
		"c_want" = ["", 0, 10], 
		"com" = false,
	}, 
}

var random_names = ["Vod", "Star", "Kit", "Healy", "Fast", "Kote", "Jumper", "Variant", "Sircumferance", "Jaig", "Effo", "Dar"]

var Pronoun_Sibling = [["Brother", "Sister", "Vod"], ["brother", "sister", "vod"]]
var Pronoun_Cap = [["He", "Him", "His"], ["She", "Her", "Hers"], ["They", "Them", "Theirs"]]
var Pronoun_Low = [["he", "him", "his"], ["she", "her", "hers"], ["they", "them", "theirs"]]
var Pronoun_Verb =[["is", "is", "are"], ["has", "has", "have"]]

var day_count = 1

func _ready() -> void:
	Globals.object_interaction.connect(_on_global_interaction)
	#set_player_name("random")
	#set_player_number("random")

func number_length():
	var only_numbers = true
	var numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "_"]
	for c in str(Dialogic.VAR.get("temp_value")):
		if numbers.has(c):
			pass
		else:
			only_numbers = false
	
	if only_numbers:
		return len(str(Dialogic.VAR.get("temp_value")))
	else:
		return 50

func set_player_name(name_value) -> void:
	if name_value == "random":
		PlayerData.set("name", random_names[randi_range(0, len(random_names)-1)])
	else:
		PlayerData.set("name", Dialogic.VAR.get("temp_value"))
	Dialogic.VAR.set("PlayerName", PlayerData["name"])

func set_player_number(number_value) -> void:
	if number_value == "random":
		var count = [1, 2, 3, 4]
		PlayerData.set("number", "")
		for digit in count:
			PlayerData.set("number", PlayerData["number"]+str(randi_range(0, 9)))
	
	else:
		PlayerData.set("number", str(Dialogic.VAR.get("temp_value")))
	Dialogic.VAR.set("PlayerName", "CT-" + PlayerData["number"])

func set_player_prnoun(choice) -> void:
	PlayerData.set("gender", choice)

### THE FUNCTION THAT ALLOWS FOR INTER OBJECT AND SCRIPT COMMUNICATION ###
signal object_interaction
func interact_with(reciever : String, sender : String, message = null ):
	object_interaction.emit(reciever, sender, message)
### THE SINGLE MOST IMPORTANT SCRIPT IMO ~~ HOW TO USE IT ###
#func _ready() -> void:
	#Globals.object_interaction.connect(_on_global_interaction)
#
#func _on_global_interaction(reciever, sender, message):
	#pass

func _on_global_interaction(reciever, sender, message):
	match reciever:
		"global_new_day":
			day_turnover()

func budget_check(value_to_check, price):
	if (value_to_check - price) < 0:
		#print("budget check false")
		return false
	else:
		#print("budget check true")
		return true


func day_turnover() -> void:
	#Up the values
	BuySheet.ResourceInventory.set("wood", (BuySheet.ResourceInventory["wood"]+BuySheet.DailyCosts["wood"]))
	BuySheet.ResourceInventory.set("stone", (BuySheet.ResourceInventory["stone"]+BuySheet.DailyCosts["stone"]))
	BuySheet.ResourceInventory.set("labor", BuySheet.DailyCosts["labor"])
	BuySheet.ResourceInventory.set("water", (BuySheet.ResourceInventory["water"]+BuySheet.DailyCosts["water"]))
	BuySheet.ResourceInventory.set("food", (BuySheet.ResourceInventory["food"]+BuySheet.DailyCosts["food"]))
	day_count += 1
	Checklist["days"]["has"] += 1
	Checklist["days"]["c_want"][1] += 1
	
	#rotate through the building plots to calculate the new costs for next day forward
	var temp_c_want_plant = 0
	for plot in BuySheet.BuildingInventory:
		BuySheet.BuildingInventory[plot].set("worked_today", false)
		if BuySheet.BuildingInventory[plot]["type"] == "farm":
			if BuySheet.BuildingInventory[plot]["crop_planted"] == Checklist["farm"]["c_want"][0]:
				temp_c_want_plant += 1
		
		if BuySheet.BuildingInventory[plot]["queued"] != "":
			match BuySheet.BuildingInventory[plot]["type"]:
				"community":
					if BuySheet.BuildingInventory[plot]["queued"] != "rubble":
						Checklist["community"]["has"] += 1
						if BuySheet.BuildingInventory[plot]["queued"] == Checklist["community"]["c_want"][0]:
							Checklist["community"]["c_want"][1] += 1
					else:
						Checklist["community"]["has"] -= 1
						if BuySheet.BuildingInventory[plot]["built"] == Checklist["community"]["c_want"][0]:
							Checklist["community"]["c_want"][1] -= 1
				
				"house":
					if BuySheet.BuildingInventory[plot]["queued"] != "rubble":
						Checklist["house"]["has"] += 1
						if BuySheet.BuildingInventory[plot]["queued"] == Checklist["house"]["c_want"][0]:
							Checklist["house"]["c_want"][1] += 1
					else:
						Checklist["house"]["has"] -= 1
						if BuySheet.BuildingInventory[plot]["built"] == Checklist["house"]["c_want"][0]:
							Checklist["house"]["c_want"][1] -= 1
				
				###FINISH WITH THE CROPS!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				"farm":
					if BuySheet.BuildingInventory[plot]["queued"] != "rubble":
						Checklist["farm"]["has"] += 1
					else:
						Checklist["farm"]["has"] -= 1
			
			
			##handle the water swaps
			if BuySheet.BuildingInventory[plot]["queued"] == "well":
				Checklist["water"]["has"] += 1
				BuySheet.DailyCosts["water"] += 50
				Checklist["water"]["c_want"][1] += 1
			if BuySheet.BuildingInventory[plot]["built"] == "well":
				Checklist["water"]["has"] -= 1
				BuySheet.DailyCosts["water"] -= 50
				Checklist["water"]["c_want"][1] += 1
			
			#swap queued to built
			BuySheet.BuildingInventory[plot].set("built", BuySheet.BuildingInventory[plot]["queued"])
			BuySheet.BuildingInventory[plot].set("queued", "")
	
	#update the farming want value since it tracks plants not the farm itself
	Checklist["farm"].set("c_want", [Checklist["farm"]["c_want"][0], temp_c_want_plant, Checklist["farm"]["c_want"][2]])
	
	interact_with("GLOBAL_ALERT", "global", "new_day")

func building_purchase(building_array):
	if building_array[0] == "rubble":
		building_array[1] = building_array[1] * -1
		building_array[2] = building_array[2] * -1
	
	BuySheet.ResourceInventory["wood"] -= building_array[1]
	BuySheet.ResourceInventory["stone"] -= building_array[2]
	BuySheet.ResourceInventory["labor"] -= building_array[3]

func farming_costs(farm_array):
	BuySheet.ResourceInventory["water"] -= farm_array[0]
	BuySheet.ResourceInventory["labor"] -= farm_array[1]
