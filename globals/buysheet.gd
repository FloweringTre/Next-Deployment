extends Node

# to house all building costs in one central location

# ~Inventory~
var ResourceInventory : Dictionary = {
	"stone" = 100,
	"wood" = 100,
	"labor" = 100
}

var BuildingInventory : Dictionary = {
	"shelter_1" = "rubble",
	"shelter_2" = "rubble",
}

var ShelterDwellings : Dictionary = {
	"rubble" = {
		"name" = "Destroy/Rubble",
		"about" = "Go back to starting point, get a partial return of your materials.",
		"image" = 0,
		"wood" = 0,
		"stone" = 0,
		"labor" = 15
	},
	"log_house" = {
		"name" = "Wooden House",
		"about" = "Basic house, good for protecting civilians from generic elements.",
		"image" = 1,
		"wood" = 20,
		"stone" = 0,
		"labor" = 25
	},
	"adobe_house" = {
		"name" = "Adobe/Earthen House",
		"about" = "Packed earthen house with stone and wood framing. Good for protecting against heat and cold.",
		"image" = 2,
		"wood" = 20,
		"stone" = 20,
		"labor" = 15
	},
	"brick_house" = {
		"name" = "Brick House",
		"about" = "Strong house, able to handle extreme weather conditions or external dangers to civilians.",
		"image" = 3,
		"wood" = 0,
		"stone" = 30,
		"labor" = 25
	}
}
