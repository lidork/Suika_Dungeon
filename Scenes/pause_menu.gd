extends Control



func _ready():
	resume()

func resume():
	visible = false
	get_tree().paused = false
	
func pause():
	visible = true
	get_tree().paused = true
	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		


func _on_resume_pressed():
	resume() # Replace with function body.


func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
	



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	


func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
