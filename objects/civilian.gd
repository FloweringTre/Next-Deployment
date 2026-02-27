extends Node2D

var mouse_on : bool = false
var mouse_pressed : bool = false

@export var char_name : String
@export var char_color : Color = Color(1.0, 1.0, 1.0, 0.0)
@export var start_frame : int = -1

var old_loc : Vector2
var new_loc : Vector2

func _ready() -> void:
	Globals.object_interaction.connect(_on_global_interaction)
	$nameLabel.visible = false
	character_setup()

func _on_global_interaction(reciever, sender, message):
	if sender == "Build_Menu" or reciever == "Build_Menu":
		$Area2D/CollisionShape2D.disabled = !$Area2D/CollisionShape2D.disabled

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and mouse_on:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed
			
			if mouse_pressed:
				$Sprite2D.frame = start_frame+1
				$AnimationPlayer.play("hang")
				Globals.interact_with("GLOBAL_ALERT", char_name, "carrying")
			else:
				$Sprite2D.frame = start_frame
				$AnimationPlayer.play("RESET")
				$".".position += Vector2(0, 150)*$".".scale
				Globals.interact_with("GLOBAL_ALERT", char_name, "carrying")
	
	elif event is InputEventMouseMotion and mouse_pressed:
		$".".position = get_global_mouse_position()

func character_setup() -> void:
	if char_name == "":
		char_name = Globals.random_names[randi_range(0, len(Globals.random_names)-1)]
	
	if char_color == Color(1.0, 1.0, 1.0, 0.0):
		char_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)
	
	if start_frame == -1:
		start_frame = randi_range(0, 4)*2
	
	$Sprite2D.frame = start_frame
	$nameLabel.text = char_name
	$nameLabel.add_theme_color_override("font_color", char_color)
	$Sprite2D.self_modulate = char_color

func _on_area_2d_mouse_entered() -> void:
	$nameLabel.visible = true
	mouse_on = true

func _on_area_2d_mouse_exited() -> void:
	$nameLabel.visible = false
	mouse_on = false
