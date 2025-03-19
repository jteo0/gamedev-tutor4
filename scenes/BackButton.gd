extends TextureButton
	
func _on_pressed() -> void:
	print("press")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
