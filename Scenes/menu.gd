extends Control


#TODO FINISH THIS LMAOOOOOOOO
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/board.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")


func _on_quit_pressed():
	get_tree().quit()
