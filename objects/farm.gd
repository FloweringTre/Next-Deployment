extends Node2D

var mouse_on : bool = false
@export var plot_spot : String
@export var field_level : String 
var crop : Dictionary

var can_harvest : bool = false
var is_open : bool = false

func _ready() -> void:	
	Globals.object_interaction.connect(_on_global_interaction)
	_on_area_2d_mouse_exited()
	set_up()

func set_up() -> void:
	$fieldsprite.texture = BuySheet.FarmingFields[BuySheet.BuildingInventory[plot_spot]["built"]]["source"]
	$fieldsprite.frame = BuySheet.FarmingFields[BuySheet.BuildingInventory[plot_spot]["built"]]["image"][0]
	field_level = BuySheet.BuildingInventory[plot_spot]["built"]
	crop = BuySheet.CropList[BuySheet.BuildingInventory[plot_spot]["crop_planted"]].duplicate(true)
	$harvestParticle.scale_amount_max = $harvestParticle.scale_amount_max*$".".scale.x
	$harvestParticle.scale_amount_min = $harvestParticle.scale_amount_min*$".".scale.x
	$readyParticle.scale_amount_max = $readyParticle.scale_amount_max*$".".scale.x
	$readyParticle.scale_amount_min = $readyParticle.scale_amount_min*$".".scale.x
	
	crop_growth()
	costs()

func _on_global_interaction(reciever, sender, message):
	if sender == "Build_Menu" or reciever == "Build_Menu":
		$Area2D/CollisionShape2D.disabled = !$Area2D/CollisionShape2D.disabled
	
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
					field_level = BuySheet.BuildingInventory[plot_spot]["built"]
					$fieldsprite.frame = BuySheet.FarmingFields[BuySheet.BuildingInventory[plot_spot]["built"]]["image"][0]
					$cone.visible = false
					$Area2D/CollisionShape2D.disabled = false
					crop = BuySheet.CropList[BuySheet.BuildingInventory[plot_spot]["crop_planted"]].duplicate(true)
					if BuySheet.BuildingInventory[plot_spot]["crop_planted"] != "none":
						BuySheet.BuildingInventory[plot_spot].set("crop_level", BuySheet.BuildingInventory[plot_spot]["crop_level"] + 1)
					crop_growth()
					costs()
					
					Globals.farming_costs([crop["water"], crop["labor_daily"]])
					Globals.interact_with("RESOURCE_UPDATE", plot_spot, "daily_costs_taken")
		
		"GLOBAL_PURCHASE":
			if plot_spot == message:
				$cone.visible = true
				$Area2D/CollisionShape2D.disabled = true
		
		"GLOBAL_DIALOG":
			if message == "start":
				$Area2D/CollisionShape2D.disabled = true
			elif message == "end":
				$Area2D/CollisionShape2D.disabled = false


func costs() -> void:
	var min
	var max
	match BuySheet.BuildingInventory[plot_spot]["built"]:
		"medium_field":
			crop.set("labor_plant", crop["labor_plant"]*2)
			crop.set("labor_daily", crop["labor_daily"]*2)
			crop.set("labor_daily", crop["labor_daily"]*2)
			crop.set("water", crop["water"]*2)
			min = crop["harvest"][0]*2
			max = crop["harvest"][1]*2
			crop.set("harvest", [min, max])
		"large_field":
			crop.set("labor_plant", crop["labor_plant"]*3)
			crop.set("labor_daily", crop["labor_daily"]*3)
			crop.set("labor_daily", crop["labor_daily"]*3)
			crop.set("water", crop["water"]*3)
			min = crop["harvest"][0]*3
			max = crop["harvest"][1]*3
			crop.set("harvest", [min, max])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and mouse_on:
		#print(is_open, " - ", plot_spot
		if can_harvest:
			harvest()
		else:
			Globals.interact_with("Build_Menu", plot_spot, $".".position)
			is_open = !is_open
		#print(is_open)

func _on_area_2d_mouse_entered() -> void:
	mouse_on = true
	$fieldsprite.modulate = Color(1, 1, 1, 1)
	$crops.modulate = Color(1, 1, 1, 1)
	#print("mouse on")

func _on_area_2d_mouse_exited() -> void:
	mouse_on = false
	$fieldsprite.modulate = Color(0.667, 0.667, 0.667, 1.0)
	$crops.modulate = Color(0.667, 0.667, 0.667, 1.0)
	#print("mouse off")

func crop_positions() -> void:
	#print(field_level)
	match field_level:
		"rubble":
			pass
		"small_field":
			%row_1.position = Vector2(-32, 3)
			%row_1.visible = true
			%row_2.visible = false
			%row_3.visible = false
		"medium_field":
			%row_1.position = Vector2(-52, 19)
			%row_2.position = Vector2(-13, -39)
			%row_1.visible = true
			%row_2.visible = true
			%row_3.visible = false
		"large_field":
			%row_1.position = Vector2(-56, 42)
			%row_2.position = Vector2(-31, -19)
			%row_1.visible = true
			%row_2.visible = true
			%row_3.visible = true
 
func crop_growth() -> void:
	crop_positions()
	if BuySheet.BuildingInventory[plot_spot]["crop_level"] == 0:
		%row_1.visible = false
		%row_2.visible = false
		%row_3.visible = false
		#print("no crops")
	else:
		var count = 0
		for index in crop["grown"]:
			if index == BuySheet.BuildingInventory[plot_spot]["crop_level"]:
				%row_1.frame = crop["frame"][count]
				%row_2.frame = crop["frame"][count]
				%row_3.frame = crop["frame"][count]
			count += 1
			if BuySheet.BuildingInventory[plot_spot]["crop_level"] == crop["grown"][-1]:
				can_harvest = true
				$readyParticle.emitting = true

func harvest() -> void:
	$readyParticle.emitting = false
	var atlas = AtlasTexture.new()
	atlas.atlas = BuySheet.FarmingFields[BuySheet.BuildingInventory[plot_spot]["built"]]["source"]
	atlas.region = Rect2((crop["image"][0]*crop["image"][2]), (crop["image"][1]*crop["image"][3]), (crop["image"][2]), (crop["image"][3]))
	$harvestParticle.texture = atlas
	var harvest_amount = randi_range(crop["harvest"][0],crop["harvest"][1])
	
	$harvestParticle.amount = harvest_amount
	$harvestParticle.emitting = true
	
	can_harvest = false
	%row_1.visible = false
	%row_2.visible = false
	%row_3.visible = false
	BuySheet.BuildingInventory[plot_spot].set("crop_planted", "none")
	BuySheet.BuildingInventory[plot_spot].set("crop_level", 0)
	BuySheet.ResourceInventory.set("food", BuySheet.ResourceInventory["food"]+harvest_amount)
	crop = BuySheet.CropList[BuySheet.BuildingInventory[plot_spot]["crop_planted"]].duplicate(true)
	Globals.interact_with("RESOURCE_UPDATE", plot_spot, "food_harvested")
