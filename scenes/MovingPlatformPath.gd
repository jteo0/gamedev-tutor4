extends PathFollow2D

@export var move_speed: float = 0.1
@onready var platform: TileMapLayer = $MovingPlatform
var start_moving = false
var reverse = false

func _process(delta):
	if start_moving:
		if !reverse:
			progress_ratio += move_speed * delta
			if progress_ratio == 1.0:
				reverse = true
		else:
			progress_ratio -= move_speed * delta
			if progress_ratio == 0.0:
				reverse = false

func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	if body.get_name() == "Player":
		start_moving = true
