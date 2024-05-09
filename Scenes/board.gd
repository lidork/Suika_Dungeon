extends Node2D


const OUT_OF_BOUNDS = -999

@export var Monster1: PackedScene

@onready var Monsters := $Monsters
@onready var Next_Sprite := $Next_sprite
@onready var Fusion_Timer := $Fusion_timer
@onready var Spawn_Timer := $Spawn_timer
@onready var Score := $Score_number
@onready var Player := $Player
@onready var Current_Sprite := $Current_sprite
@onready var Fail := $Fail_Area
@onready var Lose_Menu := $Lose_Menu


var music = preload("res://Sound/Charmall_Overture_in_D_minor_final.mp3")
var score = 0
var nextMonsterType 
var current_monster
var next_monster
var game_loss = false

func _physics_process(delta):
	Current_Sprite.position.x = Player.position.x
	pass


func _ready():
	#instantiate the next monster
	next_monster = Monster1.instantiate()
	Monsters.add_child(next_monster)
	next_monster.gravity_scale = 0
	next_monster.position.x = OUT_OF_BOUNDS
	next_monster.position.y = OUT_OF_BOUNDS
	next_monster_set()
	

	#instantiate current
	current_monster = Monster1.instantiate()
	Monsters.add_child(current_monster)
	current_monster.gravity_scale = 0
	current_monster.position.x = OUT_OF_BOUNDS
	current_monster.position.y = OUT_OF_BOUNDS - 200
	
	
	current_monster_set()
	next_monster_set()
	Engine.time_scale = 1
	AudioManager.play_sound(music, -20.0)

func _input(event):
	if event.is_action_pressed("click") and Spawn_Timer.is_stopped() and game_loss == false:
		
		var new_monster = Monster1.instantiate()
		Monsters.add_child(new_monster)
		new_monster.set_type(current_monster.type)
		new_monster.set_size()
		
		current_monster_set()
		next_monster_set()
		
		#connect the new monster to the fusionned signal
		new_monster.connect("fusionned", _on_monster_fusionned)
		new_monster.position.x = Player.position.x
		new_monster.position.y = Player.position.y + 30
		Spawn_Timer.start()
		

#set the next monster's display
func next_monster_set():
	nextMonsterType = randi_range(next_monster.Type.TINY_ZOMBIE, next_monster.Type.SKELETON)
	next_monster.set_type(nextMonsterType)
	Next_Sprite.texture = next_monster.get_type_sprite()

#sets the current's monster's display and to be ready to release
func current_monster_set():
	current_monster.set_type(nextMonsterType)
	Current_Sprite.texture = current_monster.get_type_sprite()
	#TODO make this more scaleable in the future
	if nextMonsterType == current_monster.Type.ZOMBIE or nextMonsterType == current_monster.Type.SKELETON:
		Current_Sprite.position.y = Player.position.y + 35
	else:
		Current_Sprite.position.y = Player.position.y + 20
	var curr_scale = current_monster.get_monster_scale()
	Current_Sprite.scale = Vector2(curr_scale,curr_scale)

#after collision detected, handle colliding monsters
func _on_monster_fusionned(monster_a, monster_b):
	if monster_a.type != monster_a.Type.BIG_DEMON:
		Fusion_Timer.start()
		await Fusion_Timer.timeout
		#lerp returns value between the first and second position, 0.5(t) represents how far from point a to go
		var lower_position = monster_b.position.lerp(monster_a.position, 0.5)
		call_deferred("create_fusionned_monster", monster_b.type, lower_position, monster_b.rotation)
	score += monster_a.get_score()
	Score.text = str(score)
	monster_a.delete()
	monster_b.delete()


#ready up the fusioned monster
#TODO maybe animation on fusion 	
func create_fusionned_monster(monster_type, monster_position, monster_rotation):
	var fusioned = Monster1.instantiate()
	Monsters.add_child(fusioned)
	fusioned.set_type(monster_type + 1)
	fusioned.set_size()
	fusioned.connect("fusionned", _on_monster_fusionned)
	fusioned.position = monster_position
	fusioned.rotation = monster_rotation
	



func _on_fail_area_game_lost():
	game_loss = true
	Lose_Menu.visible = true
	Engine.time_scale = 0


func _on_new_round_pressed():
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_label_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
