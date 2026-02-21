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
		"global_building":
			var random_upgrade = randi_range(1,3)
			while random_upgrade == message:
				random_upgrade = randi_range(1,3)
				print("rerolling...")
			
			var can_go_thru = false
			match random_upgrade:
				1:
					if budget_check(BuySheet.ResourceInventory["wood"], 25) && budget_check(BuySheet.ResourceInventory["labor"], 25):
						BuySheet.ResourceInventory.set("wood", (BuySheet.ResourceInventory["wood"]-25))
						BuySheet.ResourceInventory.set("labor", (BuySheet.ResourceInventory["labor"]-25))
						can_go_thru = true
				2:
					if budget_check(BuySheet.ResourceInventory["stone"], 15) && budget_check(BuySheet.ResourceInventory["wood"], 15) && budget_check(BuySheet.ResourceInventory["labor"], 25):
						BuySheet.ResourceInventory.set("wood", (BuySheet.ResourceInventory["wood"]-15))
						BuySheet.ResourceInventory.set("stone", (BuySheet.ResourceInventory["stone"]-15))
						BuySheet.ResourceInventory.set("labor", (BuySheet.ResourceInventory["labor"]-25))
						can_go_thru = true
				3:
					if budget_check(BuySheet.ResourceInventory["stone"], 25) && budget_check(BuySheet.ResourceInventory["labor"], 25):
						BuySheet.ResourceInventory.set("stone", (BuySheet.ResourceInventory["stone"]-25))
						BuySheet.ResourceInventory.set("labor", (BuySheet.ResourceInventory["labor"]-25))
						can_go_thru = true
			
			if can_go_thru:
				interact_with(sender, "global", random_upgrade)
			else:
				interact_with("GLOBAL_ALERT", "global", "Not Enough Resources")
		
		"global_new_day":
			print("globalnewdayheard")
			BuySheet.ResourceInventory.set("wood", (BuySheet.ResourceInventory["wood"]+25))
			BuySheet.ResourceInventory.set("stone", (BuySheet.ResourceInventory["stone"]+25))
			BuySheet.ResourceInventory.set("labor", 100)
			day_count += 1
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
		building_array[1] = building_array[2] * -1
	
	BuySheet.ResourceInventory["wood"] -= building_array[1]
	BuySheet.ResourceInventory["stone"] -= building_array[2]
	BuySheet.ResourceInventory["labor"] -= building_array[3]
