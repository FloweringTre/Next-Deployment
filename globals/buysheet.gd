extends Node

# to house all building costs in one central location

# ~Inventory~
var ResourceInventory : Dictionary = {
	"stone" = 100,
	"wood" = 100,
	"labor" = 100
}

var BuildingInventory : Dictionary = {
	"shelter_1" = {
		"name" = "Home Plot 1",
		"type" = "house",
		"built" = "rubble",
		"worked_today" = false,
		"queued" = "",
	},
	"shelter_2" = {
		"name" = "Home Plot 2",
		"type" = "house",
		"built" = "rubble",
		"worked_today" = false,
		"queued" = "",
	},
	"community_1" = {
		"name" = "Community Plot 1",
		"type" = "community",
		"built" = "rubble",
		"worked_today" = false,
		"queued" = "",
	},
	"farm_1" = {
		"name" = "Farm Field 1",
		"type" = "farm",
		"built" = "rubble",
		"worked_today" = false,
		"queued" = "",
	},
}

var ShelterDwellings : Dictionary = {
	"rubble" = {
		"name" = "Destroy/Rubble",
		"about" = "Go back to starting point, get a partial return of your materials.",
		"source" = preload("res://assets/test_building-Sheet.png"),
		"image" = [0, 0, 512, 512], #x frame, y frame, width, height
		"wood" = 0,
		"stone" = 0,
		"labor" = 15
	},
	"log_house" = {
		"name" = "Wooden House",
		"about" = "Basic house, good for protecting civilians from generic elements.",
		"source" = preload("res://assets/test_building-Sheet.png"),
		"image" = [1, 0, 512, 512],
		"wood" = 20,
		"stone" = 0,
		"labor" = 25
	},
	"adobe_house" = {
		"name" = "Adobe/Earthen House",
		"about" = "Packed earthen house with stone and wood framing. Good for protecting against heat and cold.",
		"source" = preload("res://assets/test_building-Sheet.png"),
		"image" = [2, 0, 512, 512],
		"wood" = 20,
		"stone" = 20,
		"labor" = 15
	},
	"brick_house" = {
		"name" = "Brick House",
		"about" = "Strong house, able to handle extreme weather conditions or external dangers to civilians.",
		"source" = preload("res://assets/test_building-Sheet.png"),
		"image" = [3, 0, 512, 512],
		"wood" = 0,
		"stone" = 30,
		"labor" = 25
	}
}

var CommunityGathering : Dictionary = {
	"rubble" = {
		"name" = "Destroy/Rubble",
		"about" = "Go back to starting point, get a partial return of your materials.",
		"source" = preload("res://assets/test_community-Sheet.png"),
		"image" = [0, 0, 512, 512],
		"wood" = 0,
		"stone" = 0,
		"labor" = 15
	},
	"plaza" = {
		"name" = "Open Plaza",
		"about" = "Basic and safe meeting grounds for the community.",
		"source" = preload("res://assets/test_community-Sheet.png"),
		"image" = [1, 0, 512, 512],
		"wood" = 0,
		"stone" = 10,
		"labor" = 15
	},
	"covered_plaza" = {
		"name" = "Covered Plaza",
		"about" = "A shaded meeting grounds with minimal protections from the elements.",
		"source" = preload("res://assets/test_community-Sheet.png"),
		"image" = [2, 0, 512, 512],
		"wood" = 15,
		"stone" = 10,
		"labor" = 15
	},
	"town_hall" = {
		"name" = "Town Hall",
		"about" = "An enclosed building to host the community gatherings. Protects from the elements.",
		"source" = preload("res://assets/test_community-Sheet.png"),
		"image" = [3, 0, 512, 512],
		"wood" = 15,
		"stone" = 30,
		"labor" = 25
	}
}

var FarmingFields : Dictionary = {
	"rubble" = {
		"name" = "Destroy/Rubble",
		"about" = "Go back to starting point, get a partial return of your materials.",
		"source" = preload("res://assets/test_farm-Sheet.png"),
		"image" = [0, 0, 512, 512],
		"wood" = 0,
		"stone" = 0,
		"labor" = 15
	},
	"field_open" = {
		"name" = "Prepared Farm Field",
		"about" = "Ready the field for crops",
		"source" = preload("res://assets/test_farm-Sheet.png"),
		"image" = [1, 0, 512, 512],
		"wood" = 0,
		"stone" = 0,
		"labor" = 40
	},
}
