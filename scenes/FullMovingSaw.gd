extends StaticBody2D

@export var end_position: Vector2 = Vector2(100, 0)
@export var move_duration: float = 2.0

@onready var start_position: Vector2 = position

func _ready():
	start_movement()

func start_movement():
	var tween = get_tree().create_tween()
	# Move to end position
	tween.tween_property(self, "position", start_position + end_position, move_duration)
	# Move back to start position
	tween.tween_property(self, "position", start_position, move_duration)
	# Loop the movement
	tween.set_loops()
