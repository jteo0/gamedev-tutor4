# Tutorial 4
On the second level, the following features were added:
<h3>Respawn Button and Next Level Button</h3>
When the LoseScreen scene appears, it will have a button that takes the global variable CurrentLevel and respawns the player to the level it is set to. I also added the same button to the WinScreen scene to transition from Level 1 to Level 2. The following is the GDScript used for the button:

```py
extends Button

func _on_pressed() -> void:
	if get_parent().name == "WinScreen":
		CurrentLevel.current_level = "res://scenes/Level2.tscn"
	get_tree().change_scene_to_file(CurrentLevel.current_level)
```
CurrentLevel.current_level is set by default to the Level1 scene, and only switches to level2 when the button is used by WinScreen (and for testing purposes, when Level 2 is first loaded), after which everytime the player dies, they will be directed to the LoseScreen and can respawn at level 2.<br>
<h3>Half Saw, Full Saw and Moving Saw Obstacles</h3>
The obstacles used in the level are the half saws on parts of the floor, static full saws, and moving saws. The Half Saws and Full Saws are made using AnimatedSprite2D, CollisionShape2D, and the AreaTrigger scene made in the tutorial. Both AnimatedSprite2D have only one animation that has autoplay on load and loop enabled for the default spinning animation, while the AreaTrigger scene makes it so that if the player collides with either of them, the Lose Screen will load. The moving saw obstacle (FullMovingSaw scene) is just a FullSaw scene with a script attached. The script is:

```py
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
```
The tween is what moves the FullSaw up and down on a loop.<br>
<h3>New Tileset + Spikes</h3>
The new tileset was made in the same way as the tutorial one, only with the stone spritesheet instead of the dirt one. The spikes were added into the same TileMapLayer as a different set of tiles and uses seperate Area Trigger scenes to kill the player, akin to the out-of-bounds killing field from the tutorial.
<h3>Falling Weights</h3>
The falling weights were made in the same way as the falling fish from the tutorial, but their spawn rate was lowered from one every second to one every three seconds because it took too many tries to beat the level at the original spawn rate. The sprite for the weight is in a Sprite2D node, and it's collision is handled by the AreaTrigger scene made during the tutorial. It's collision layer and mask are both set at 2 so that the weights go through the tilesets and saw obstacles. The player's collision and mask layer are also set to 2 in addition to 1 so that it can collide with the falling weights. When the player is hit, the Lose Screen appears.
<h3>Moving Platform</h3>
The moving platform was made by using a Path2D node with a PathFollow2D child node, a TileMapLayer child of that, an Area2D child node of that, and a CollisionShape2D child node for that. The Path2D node is for drawing the path that the platform would follow, the PathFollow2D node is for making the platform move and where the script is attached, TileMapLayer is for making the platform itself, and the Area2D and CollisionShape2D nodes are for signalling when the player touches the platform for the first time, which I wanted to make the platform actually start moving. Below is the code attached to the PathFollow2D node:

```py
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

<h4>Resources</h4>
- https://docs.godotengine.org/en/stable/classes/class_pathfollow2d.html#class-pathfollow2d<br>
- https://stackoverflow.com/questions/75617655/when-should-i-use-a-kinematicbody-or-a-rigidbody-for-2d-platformer-characters<br>
- Godot Documentation

# Tutorial 6
<h4>References</h4>
- https://docs.godotengine.org/en/latest/tutorials/scripting/pausing_games.html<br>
- https://www.dafont.com/ (fonts)<br>
- https://www.reddit.com/r/godot/comments/18a3x1s/is_it_possible_to_overlay_a_scene_over_another/<br>
- https://forum.godotengine.org/t/exit-button-in-godot/22130<br>
- https://www.youtube.com/watch?v=e9-WQg1yMCY<br>
- https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html#pause-menu-example<br>
- https://forum.godotengine.org/t/how-can-i-disable-a-button/4947
