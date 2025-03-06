extends Button

func _on_pressed() -> void:
	if get_parent().name == "WinScreen":
		CurrentLevel.current_level = "res://scenes/Level2.tscn"
	get_tree().change_scene_to_file(CurrentLevel.current_level)
