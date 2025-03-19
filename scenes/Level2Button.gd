extends Button

func _on_pressed() -> void:
	if get_parent().name == "WinScreen":
		Global.current_level = "res://scenes/Level2.tscn"
	get_tree().change_scene_to_file(Global.current_level)
