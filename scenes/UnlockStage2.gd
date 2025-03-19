extends Label

func _ready() -> void:
	if !Global.level2_unlocked:
		visible = true
	else:
		visible = false
