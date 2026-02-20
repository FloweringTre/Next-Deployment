extends Node2D

var mouse_on : bool = false
@export var myself = "building"

func _ready() -> void:
	$Sprite2D.frame = 0
	Globals.object_interaction.connect(_on_global_interaction)
	_on_area_2d_mouse_exited()

func _on_global_interaction(reciever, sender, message):
	if reciever == myself:
		$Sprite2D.frame = message
	if reciever == "GLOBAL_ALERT":
		match message:
			"Not Enough Resources":
				$Area2D/CollisionShape2D.disabled = true
			"new_day":
				$Area2D/CollisionShape2D.disabled = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and mouse_on:
		#print(mouse_on, " - CLICK!")
		Globals.interact_with("global_building", myself, $Sprite2D.frame)

func _on_area_2d_mouse_entered() -> void:
	mouse_on = true
	$Sprite2D.modulate = Color(1, 1, 1, 1)
	#print("mouse on")


func _on_area_2d_mouse_exited() -> void:
	mouse_on = false
	$Sprite2D.modulate = Color(0.667, 0.667, 0.667, 1.0)
	#print("mouse off")
