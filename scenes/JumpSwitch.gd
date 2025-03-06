extends StaticBody2D

var button_pressed = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var button_space: CollisionShape2D = $ButtonSpace

@export var jump_boost: int = 2

func _process(delta: float) -> void:
	if button_pressed:
		sprite.texture = load("res://assets/kenney_platformerpack/PNG/Tiles/switchGreen_pressed.png")
		button_space.position.y = 50
	else:
		sprite.texture = load("res://assets/kenney_platformerpack/PNG/Tiles/switchGreen.png")
		
func _on_button_field_body_entered(body: PhysicsBody2D) -> void:
	if body.get_name() == "Player":
		body.jump_speed = -800
		button_pressed = true

func _on_button_field_body_exited(body: PhysicsBody2D) -> void:
	if body.get_name() == "Player":
		button_pressed = false
