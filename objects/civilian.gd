extends Node2D

var mouse_on : bool = false
var mouse_pressed : bool = false

@export var char_name : String
@export var is_trooper : bool

var character_values : Dictionary = {
	"hair" = [0, Color(1, 1, 1, 1)],
	"top" = [0, Color(1, 1, 1, 1)],
	"pants" = [0, Color(1, 1, 1, 1)],
	"boots" = [0, Color(0.062, 0.026, 0.006, 1.0)],
	"skin" = [0, Color(1, 1, 1, 1)],
}

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
				$AnimationPlayer.play("hang")
				Globals.interact_with("GLOBAL_ALERT", char_name, "carrying")
			else:
				$AnimationPlayer.play("RESET")
				$".".position += Vector2(0, 350)*$".".scale
				Globals.interact_with("GLOBAL_ALERT", char_name, "carrying")
	
	elif event is InputEventMouseMotion and mouse_pressed:
		$".".position = get_global_mouse_position()

func character_setup() -> void:
	if char_name == "":
		char_name = Globals.random_names[randi_range(0, len(Globals.random_names)-1)]
	
	%boots.visible = !is_trooper
	%pants.visible = !is_trooper
	%tops.visible = !is_trooper
	%armor.visible = is_trooper
	
	if is_trooper:
		character_values.set("skin", [0, Globals.human_tones[1]])
		var temp_hair = randi_range(0, 3)
		match temp_hair:
			1:
				character_values.set("hair", [1, Globals.hair_tones[randi_range(0, len(Globals.hair_tones)-1)]])
			2:
				character_values.set("hair", [2, Globals.hair_tones[randi_range(0, len(Globals.hair_tones)-1)]])
			_: # 3 or 0
				character_values.set("hair", [0, Color(1,1,1,1)])
	
	else:
		if randi_range(0, 2) == 1: #human
			character_values.set("skin", [0, Globals.human_tones[randi_range(0, len(Globals.human_tones)-1)]])
			character_values.set("hair", [randi_range(1, 4), Globals.hair_tones[randi_range(0, len(Globals.hair_tones)-1)]])
			character_values.set("top", [randi_range(0, 2), Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)])
			character_values.set("pants", [randi_range(0, 2), Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)])
		else: #twilek
			character_values.set("skin", [0, Globals.twi_tones[randi_range(0, len(Globals.twi_tones)-1)]])
			character_values.set("hair", [randi_range(5, 6), character_values["skin"][1]])
			character_values.set("top", [randi_range(0, 2), Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)])
			character_values.set("pants", [randi_range(0, 2), Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)])
	
	$nameLabel.text = char_name
	
	%tops.frame = character_values["top"][0]
	%pants.frame = character_values["pants"][0]
	%hair.frame = character_values["hair"][0]
	%tops.self_modulate = character_values["top"][1]
	%pants.self_modulate = character_values["pants"][1]
	%hair.self_modulate = character_values["hair"][1]
	%base.self_modulate = character_values["skin"][1]
	%boots.self_modulate = character_values["boots"][1]
	$AnimationPlayer.play("RESET")

func _on_area_2d_mouse_entered() -> void:
	$nameLabel.visible = true
	mouse_on = true

func _on_area_2d_mouse_exited() -> void:
	$nameLabel.visible = false
	mouse_on = false

func walk() -> void:
	%base.frame = 1
	%armor.frame = 1
	%boots.frame = 1
	%pants.frame = character_values["pants"][0] + 3
	%tops.frame = character_values["top"][0] + 3
	%hair.frame = character_values["hair"][0] + 7
func stand() -> void:
	%base.frame = 0
	%armor.frame = 0
	%boots.frame = 0
	%pants.frame = character_values["pants"][0]
	%tops.frame = character_values["top"][0]
	%hair.frame = character_values["hair"][0]
func work() -> void:
	%base.frame = 2
	%armor.frame = 2
	%boots.frame = 2
	%pants.frame = character_values["pants"][0] + 6
	%tops.frame = character_values["top"][0] + 6
	%hair.frame = character_values["hair"][0] + 14
func hang() -> void:
	%base.frame = 3
	%armor.frame = 3
	%boots.frame = 3
	%pants.frame = character_values["pants"][0] + 9
	%tops.frame = character_values["top"][0] + 9
	%hair.frame = character_values["hair"][0] + 21
