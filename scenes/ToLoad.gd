extends LinkButton

@export var scene_to_load: String = "Level1"

func _on_pressed() -> void:
	var current_scene = get_tree().get_current_scene().get_name()
	if current_scene == "GameOver":
		Global.lives = 5
	get_tree().change_scene_to_file("res://scenes/" + scene_to_load + ".tscn")
