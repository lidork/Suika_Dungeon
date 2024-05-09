extends Area2D


signal game_lost

var touched = []



func _physics_process(delta):
	for body in touched:
		if body.linear_velocity.length_squared() < 0.0001:
			game_lost.emit()
			set_physics_process(false)

func _on_body_entered(body):
	if body.has_method("set_type"):
		touched.append(body)
	

func _on_body_exited(body):
	for bodies in touched:
		var i = touched.find(body)
		if i > -1:
			touched.remove_at(i)
