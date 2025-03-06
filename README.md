# Tutorial 4
On the second level, I added the following features:
<h3>Respawn Button and Next Level Button</h3>
I added a button on the LoseScreen scene that takes the global variable CurrentLevel and respawns the player to the level it is set to. I also added the same button to the WinScreen scene to transition from Level 1 to Level 2. The following is the GDScript used for the button:
<pre>
extends Button
    
func _on_pressed() -> void:
	get_tree().change_scene_to_file(CurrentLevel.current_level)
</pre>

<h3>Full and Half Saw</h3>
