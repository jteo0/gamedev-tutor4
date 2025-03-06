extends StaticBody2D

@export var end_position: Vector2 = Vector2(100, 0)
@export var move_duration: float = 2.0

@onready var start_position: Vector2 = position

func _ready():
	start_movement()

func start_movement():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "position", start_position + end_position, move_duration)
	tween.tween_property(self, "position", start_position, move_duration)
	tween.set_loops()
