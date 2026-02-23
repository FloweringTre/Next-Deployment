extends Control

#@export_enum("house", "community", "farm") var type #0-house / 1-community / 2-farm
@export var plot_spot : String

var info_card = preload("res://objects/ui/info_box.tscn")

var type
var reference_dictionary : Dictionary

func _ready() -> void:
	$".".visible = false
	Globals.object_interaction.connect(_on_global_interaction)

func _on_global_interaction(reciever, sender, message):
	if reciever == "Build_Menu":
		#print(message)
		if message == "true":
			clear_cards()
		else:
			if sender != plot_spot:
				clear_cards()
				Globals.interact_with(plot_spot, "Build_Menu", "closed")
			set_up(sender)

func set_up(plot) -> void:
	plot_spot = plot
	type = BuySheet.BuildingInventory[plot_spot]["type"]
	%Label.text = "Building Menu for " + BuySheet.BuildingInventory[plot_spot]["name"]
	match type:
		"house": # 0
			type = 0
			reference_dictionary = BuySheet.ShelterDwellings.duplicate(true)
			%Label.visible = true
			%OptionButton.visible = false
		"community": #1
			type = 1
			reference_dictionary = BuySheet.CommunityGathering.duplicate(true)
			%Label.visible = true
			%OptionButton.visible = false
		"farm": # 2
			type = 2
			reference_dictionary = BuySheet.FarmingFields.duplicate(true)
			%Label.visible = false
			%OptionButton.select(0)
			%OptionButton.visible = true
			%OptionButton.set_item_text(0, "Building Menu for " + BuySheet.BuildingInventory[plot_spot]["name"])
			%OptionButton.set_item_text(1, "Planting Menu for " + BuySheet.BuildingInventory[plot_spot]["name"])
			if BuySheet.BuildingInventory[plot_spot]["built"] == "rubble":
				%OptionButton.set_item_disabled(1, true)
				%OptionButton.tooltip_text = "Prepare the field to plant in it."
			else:
				%OptionButton.set_item_disabled(1, false)
				%OptionButton.tooltip_text = ""
	card_generate()
	await Engine.get_main_loop().process_frame
	$".".visible = true
	#print(%bg_color.size)
	#print(%MenuBox.size)

func card_generate() -> void:
	#print(reference_dictionary)
	for key in reference_dictionary:
		#print(key)
		if key == "rubble" && type == 2:
			continue
		var new_card = info_card.instantiate()
		#get_tree().get_root().call_deferred("add_child", new_card)
		new_card.set_up_card(type, plot_spot, key)
		%CardBox.add_child(new_card)

func clear_cards() -> void:
	for child in %CardBox.get_children():
		child.queue_free()
	$".".visible = false

func _on_button_pressed() -> void:
	Globals.interact_with(plot_spot, "Build_Menu", "closed")
	clear_cards()


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			type = 2
			reference_dictionary = BuySheet.FarmingFields.duplicate(true)
			clear_cards()
			card_generate()
			$".".visible = true
		1:
			type = 3
			reference_dictionary = BuySheet.CropList.duplicate(true)
			clear_cards()
			card_generate()
			$".".visible = true
