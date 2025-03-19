extends TextureButton

func _on_pressed() -> void:
	Global.pause_pressed.emit()
