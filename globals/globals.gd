extends Node

var day_count = 1

var ResourceInventory : Dictionary = {
	"stone" = 100,
	"wood" = 100,
	"labor" = 100
}

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
					if budget_check(ResourceInventory["wood"], 25) && budget_check(ResourceInventory["labor"], 25):
						ResourceInventory.set("wood", (ResourceInventory["wood"]-25))
						ResourceInventory.set("labor", (ResourceInventory["labor"]-25))
						can_go_thru = true
				2:
					if budget_check(ResourceInventory["stone"], 15) && budget_check(ResourceInventory["wood"], 15) && budget_check(ResourceInventory["labor"], 25):
						ResourceInventory.set("wood", (ResourceInventory["wood"]-15))
						ResourceInventory.set("stone", (ResourceInventory["stone"]-15))
						ResourceInventory.set("labor", (ResourceInventory["labor"]-25))
						can_go_thru = true
				3:
					if budget_check(ResourceInventory["stone"], 25) && budget_check(ResourceInventory["labor"], 25):
						ResourceInventory.set("stone", (ResourceInventory["stone"]-25))
						ResourceInventory.set("labor", (ResourceInventory["labor"]-25))
						can_go_thru = true
			
			if can_go_thru:
				interact_with(sender, "global", random_upgrade)
			else:
				interact_with("GLOBAL_ALERT", "global", "Not Enough Resources")
		
		"global_new_day":
			print("globalnewdayheard")
			ResourceInventory.set("wood", (ResourceInventory["wood"]+25))
			ResourceInventory.set("stone", (ResourceInventory["stone"]+25))
			ResourceInventory.set("labor", 100)
			day_count += 1
			interact_with("GLOBAL_ALERT", "global", "new_day")

func budget_check(value_to_check, price):
	if (value_to_check - price) < 0:
		return false
	else:
		return true
