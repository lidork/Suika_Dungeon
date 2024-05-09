extends CharacterBody2D

const RIGHT_WALL_X = 340
const LEFT_WALL_X = 120

func _physics_process(delta):
	if get_parent().game_loss == false:
		position.x = clamp(get_viewport().get_mouse_position().x, LEFT_WALL_X, RIGHT_WALL_X)

#TODO add upgrades here
