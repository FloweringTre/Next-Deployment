extends Node2D

var mouse_on : bool = false
@export_enum("house", "community", "farm") var type #0-house / 1-community / 2-farm
@export var plot_spot : String
@export var h_frames : int
@export var v_frames : int

var reference_dictionary : Dictionary
var is_open : bool = false

func _ready() -> void:	
	Globals.object_interaction.connect(_on_global_interaction)
	_on_area_2d_mouse_exited()
	match type:
		0: # house
			reference_dictionary = BuySheet.ShelterDwellings.duplicate(true)
		1: #community
			reference_dictionary = BuySheet.CommunityGathering.duplicate(true)
		2: # farm
			reference_dictionary = BuySheet.FarmingFields.duplicate(true)
	set_up()

func set_up() -> void:
	$Sprite2D.texture = reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["source"]
	$Sprite2D.hframes = h_frames
	$Sprite2D.vframes = v_frames
	$Sprite2D.frame = reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["image"][0]


func _on_global_interaction(reciever, sender, message):
	match reciever:
		plot_spot:
			if sender == "Build_Menu" && message == "closed":
				is_open = false
				#print("build menu swapped - ", plot_spot)
		
		"GLOBAL_ALERT":
			match message:
				"Not Enough Resources":
					$Area2D/CollisionShape2D.disabled = true
				"new_day":
					$Sprite2D.frame = reference_dictionary[BuySheet.BuildingInventory[plot_spot]["built"]]["image"][0]
					$cone.visible = false
					$Area2D/CollisionShape2D.disabled = false
		
		"GLOBAL_PURCHASE":
			if plot_spot == message:
				$cone.visible = true
				$Area2D/CollisionShape2D.disabled = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and mouse_on:
		#print(is_open, " - ", plot_spot)
		Globals.interact_with("Build_Menu", plot_spot, str(is_open))
		is_open = !is_open
		#print(is_open)

func _on_area_2d_mouse_entered() -> void:
	mouse_on = true
	$Sprite2D.modulate = Color(1, 1, 1, 1)
	#print("mouse on")


func _on_area_2d_mouse_exited() -> void:
	mouse_on = false
	$Sprite2D.modulate = Color(0.667, 0.667, 0.667, 1.0)
	#print("mouse off")
