extends Node

var day_count = 1

func _ready() -> void:
	Globals.object_interaction.connect(_on_global_interaction)

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
			#print("globalnewdayheard")
			BuySheet.ResourceInventory.set("wood", (BuySheet.ResourceInventory["wood"]+25))
			BuySheet.ResourceInventory.set("stone", (BuySheet.ResourceInventory["stone"]+25))
			BuySheet.ResourceInventory.set("labor", 100)
			day_count += 1
			
			for plot in BuySheet.BuildingInventory:
				BuySheet.BuildingInventory[plot].set("worked_today", false)
				if BuySheet.BuildingInventory[plot]["queued"] != "":
					BuySheet.BuildingInventory[plot].set("built", BuySheet.BuildingInventory[plot]["queued"])
				BuySheet.BuildingInventory[plot].set("queued", "")
			
			interact_with("GLOBAL_ALERT", "global", "new_day")

func budget_check(value_to_check, price):
	if (value_to_check - price) < 0:
		#print("budget check false")
		return false
	else:
		#print("budget check true")
		return true


func purchase(building_array):
	if building_array[0] == "rubble":
		building_array[1] = building_array[1] * -1
		building_array[2] = building_array[2] * -1
	
	BuySheet.ResourceInventory["wood"] -= building_array[1]
	BuySheet.ResourceInventory["stone"] -= building_array[2]
	BuySheet.ResourceInventory["labor"] -= building_array[3]
