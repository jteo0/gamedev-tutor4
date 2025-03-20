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
For tutorial 6, the following features were added/polished:<br>
<h3>Main Menu</h3>
<p>The main menu has a ControlNode as its rood node, with a MarginContainer child node comprising of a VboxContainer that contains the Title (Label), HBoxContainer with textures (HboxContainer, TextureRect), and three link buttons which start the game, lead to the stage select screen, and exit the game respectively.</p>
<p>The textures in the Hbox are animated, which is done by making a new animation texture in the textures variable of TextureRect, setting it to 2 frames, and putting in the sprites I wanted for each frame of the animated texture.</p>
<p>The three link buttons use this script to work:</p>

```py
extends LinkButton

@export var scene_to_load: String = "Level1"

func _on_pressed() -> void:
	var current_scene = get_tree().get_current_scene().get_name()
	if current_scene == "GameOver":
		Global.lives = 5
	get_tree().change_scene_to_file("res://scenes/" + scene_to_load + ".tscn")

```
The MainMenu also has a background made using a TextureRectangle that's a direct child of the root node.
<h3>Stage Selection</h3>
<p>The stage select scene constists of two panel containers arranged using a MarginContainer and an HBoxContainer and a back button leading back to the menu outside of the MarginContainer. Inside each panel container is a VBoxContainer which contains a TextureRect with an image of the corresponding stage and a Button under it with the name of the stage. Under the stage 2 button there is a label that only appears if the player hasn't unlocked the second stage, after which it won't appear.</p>
The following is the script used in the buttons for loading the stages:<br>

```py
extends Button

@export var scene_to_load: String = "Level1"

func _ready() -> void:
	if scene_to_load == "Level2":
		if !Global.level2_unlocked:
			disabled = true

func _on_pressed() -> void:
	if !disabled:
		get_tree().change_scene_to_file("res://scenes/" + scene_to_load + ".tscn")

```
The next one is the script for making the label under stage 2 appear and disappear:<br>

```py
extends Label

func _ready() -> void:
	if !Global.level2_unlocked:
		visible = true
	else:
		visible = false

```
The back button is an animated TextureButton (animated the same way as the TextureRect in the main menu) that uses the following script:<br>

```py
extends TextureButton
	
func _on_pressed() -> void:
	print("press")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

```
<h3>Exit Game</h3>
There are two ways to exit the game, through the main menu link button that says EXIT GAME, and the button in the pause screen that says EXIT GAME. Both use the following script to exit the game:<br>

```py
func _on_exit_pressed() -> void:
	get_tree().quit()
```
<h3>Life Counter and GUI</h3>
The GUI scene contains the life counter for the player and a pause button (to be explained later). The life counter checks the lives variable in the global script global.gd, and the label adjusts accordingly.<br>

```py
extends Label

func _process(_delta):
	self.text = "Lives : " + str(Global.lives)
```
Every death method in stages 1 and 2 will subtract 1 from Global.lives, so and reset the stage, so that the player restarts the stage and has one less life every time. Transitioning from stage 1 to 2 will not reset the amount of lives the player has, but getting a game over and restarting or quitting to the menu and trying again will.
<h3>Game Over</h3>
When the amount of lives the player has reaches zero, the game over scene will appear. On it, there is a label proclaming 'GAME OVER' and a LinkButton that leads back to the main menu. The script for the link button is the same as the LinkButtons on the main menu.
<h3>Level Transitions</h3>
When the player reaches the objective in stage 1, the WinScreen scene will appear. It consists of a TextureRect for the background and a button that leads to stage 2.<br>

```py
extends Button

func _on_pressed() -> void:
	if get_parent().name == "WinScreen":
		Global.current_level = "res://scenes/Level2.tscn"
	get_tree().change_scene_to_file(Global.current_level)
```
<h3>Pausing</h3>
<p>In the scenes Level1 and Level2, the player can pause the game by either pressing the escape key or clicking on the pause button on the top right of the screen. When either is done, the game will pause, and the PauseMenu scene will be overlaid above whichever level is playing.</p>
<p>In the case of the pause button, pressing on it will emit a signal that connects to the pause menu scene. When it is received, the pause menu will appear.</p>

```py
# PauseButton.gd
extends TextureButton

func _on_pressed() -> void:
	Global.pause_pressed.emit()

# The signal in global.gd so that a different scene can receive it
signal pause_pressed

# in PauseMenu.gd
func _ready() -> void:
	Global.pause_pressed.connect(_on_pause_pressed_received)

func pause():
	get_tree().paused = true
	visible = true

func _on_pause_pressed_received():
	pause()
```
<p>The pause menu as a whole consists of a resume button that resumes the game (clicking escape again also resumes the game, but clicking on the pause button on the top right does not), the quit to menu button that returns the player to the main menu, and the exit game button that exits the game. The following is the script as a whole for the PauseMenu scene:</p>

```py
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

```
<p>Also, the PauseMenu scene as a whole has its ProcessMode set to always so that it still works even when the rest of the game is paused.</p>

<h3>Fonts</h3>
For the font in the labels and buttons, I imported fonts from dafont.com and dragged them into the font variable of each nodes' Theme Override and adjusted their sizes accordingly.<br>
<h4>References</h4>
- https://docs.godotengine.org/en/latest/tutorials/scripting/pausing_games.html<br>
- https://www.dafont.com/ (fonts)<br>
- https://www.reddit.com/r/godot/comments/18a3x1s/is_it_possible_to_overlay_a_scene_over_another/<br>
- https://forum.godotengine.org/t/exit-button-in-godot/22130<br>
- https://www.youtube.com/watch?v=e9-WQg1yMCY<br>
- https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html#pause-menu-example<br>
- https://forum.godotengine.org/t/how-can-i-disable-a-button/4947
