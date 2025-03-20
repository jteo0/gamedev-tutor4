extends Control

func _ready() -> void:
	Global.pause_pressed.connect(_on_pause_pressed_received)
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func resume():
	get_tree().paused = false
	visible = false
	
func pause():
	get_tree().paused = true
	visible = true

func _on_resume_pressed() -> void:
	resume()
	
func _on_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_pause_pressed_received():
	pause()
