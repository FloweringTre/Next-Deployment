extends Control

#@export_enum("house", "community", "farm") var type #0-house / 1-community / 2-farm
@export var plot_spot : String

var info_card = preload("res://objects/ui/info_box.tscn")

var type
var reference_dictionary : Dictionary
var width

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
	width = 6
	match type:
		"house": # 0
			type = 0
			reference_dictionary = BuySheet.ShelterDwellings.duplicate(true)
		"community": #1
			type = 1
			reference_dictionary = BuySheet.CommunityGathering.duplicate(true)
		"farm": # 2
			type = 2
			reference_dictionary = BuySheet.FarmingFields.duplicate(true)
	card_generate()
	await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame
	%Label.text = "Building Menu for " + BuySheet.BuildingInventory[plot_spot]["name"]
	%bg_color.size = Vector2(width, 470)
	$".".visible = true
	#print(%bg_color.size)
	#print(%MenuBox.size)

func card_generate() -> void:
	#print(reference_dictionary)
	for key in reference_dictionary:
		#print(key)
		var new_card = info_card.instantiate()
		#get_tree().get_root().call_deferred("add_child", new_card)
		new_card.set_up_card(type, plot_spot, key)
		%CardBox.add_child(new_card)
		width += 189

func clear_cards() -> void:
	for child in %CardBox.get_children():
		child.queue_free()
	$".".visible = false

func _on_button_pressed() -> void:
	Globals.interact_with(plot_spot, "Build_Menu", "closed")
	clear_cards()
