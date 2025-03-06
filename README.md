# Tutorial 4
On the second level, the following features were added:
<h3>Respawn Button and Next Level Button</h3>
I added a button on the LoseScreen scene that takes the global variable CurrentLevel and respawns the player to the level it is set to. I also added the same button to the WinScreen scene to transition from Level 1 to Level 2. The following is the GDScript used for the button:

```py
extends Button

func _on_pressed() -> void:
	if get_parent().name == "WinScreen":
		CurrentLevel.current_level = "res://scenes/Level2.tscn"
	get_tree().change_scene_to_file(CurrentLevel.current_level)
```
CurrentLevel.current_level is set by default to the Level1 scene, and only switches to level2 when the button is used by WinScreen, after which everytime the player dies, they will be directed to the LoseScreen and can respawn at level 2.<br>
<h3>Half Saw, Full Saw and Moving Saw Obstacles</h3>
The obstacles used in the level are the half saws on parts of the floor, static full saws, and moving saws. The Half Saws and Full Saws are made using AnimatedSprite2D, CollisionShape2D, and the AreaTrigger scene made in the tutorial. The animated sprite has only one animation that plays on loop for both
<h3>New Tileset + Spikes</h3>
<h3>Falling Weights</h3>
<h3>Moving Platform</h3>
The moving platform was made by using a Path2D node with a PathFollow2D child node, a TileMapLayer child of that, an Area2D child node of that, and a CollisionShape2D child node for that. The Path2D node is for drawing the path that the platform would follow, the PathFollow2D node is for making the platform move and where the script is attached, TileMapLayer is for making the platform itself, and the Area2D and CollisionShape2D nodes are for signalling when the player touches the platform for the first time, which I wanted to make the platform actually start moving. Below is the code attached to the PathFollow2D node:

```py
extends StaticBody2D

var button_pressed = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var button_space: CollisionShape2D = $ButtonSpace

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

```
<h3>Jump Boost Switch</h3>
When pressed (when the player collides with it), the player gets a boost to jump height, switching it from -425 in level 2 to -800. It's coded to switch to the pressed sprite when the player enters the body of the child Area2D node (ButtonField), and to return to the normal sprite when it exists. Below is the full code:

```py
extends StaticBody2D

var button_pressed = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var button_space: CollisionShape2D = $ButtonSpace

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
```

<h3>Background</h3>
The background uses Sprite2D as a child node of CanvasLayer. The Sprite2D is used for the background itself, and the is CanvasLayer so that it automatically follows the camera.
