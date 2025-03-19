extends Button

@export var scene_to_load: String = "Level1"

func _ready() -> void:
	if scene_to_load == "Level2":
		if !Global.level2_unlocked:
			disabled = true

func _on_pressed() -> void:
	if !disabled:
		get_tree().change_scene_to_file("res://scenes/" + scene_to_load + ".tscn")
