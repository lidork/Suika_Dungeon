extends RigidBody2D
class_name Monster

signal fusionned(monster)


enum Type{
	TINY_ZOMBIE,
	ZOMBIE,
	SKELETON,
	SLUG,
	GOBLIN,
	ORC,
	MASK_ORC,
	IMP,
	BIG_ZOMBIE,
	BIG_OGRE,
	BIG_DEMON,
}

#written as var but should be like const
@onready var MONSTER_INFO := {
	Type.TINY_ZOMBIE : {
		"score" : 2,
		"sprite" : preload("res://Graphics/Tiny_Zombie_Sprite.png"),
		"collision" : $TinyZombieCollision,
		"scale" : 2,
	},
	Type.ZOMBIE : {
		"score" : 4,
		"sprite" : preload("res://Graphics/Zombie_Sprite.png"),
		"collision" : $ZombieCollision,
		"scale" : 2.4
	},
	Type.SKELETON : {
		"score" : 6,
		"sprite" : preload("res://Graphics/Skeleton_Sprite.png"),
		"collision" : $SkeletonCollision,
		"scale" : 2.9
	},
	Type.SLUG : {
		"score" : 8,
		"sprite" : preload("res://Graphics/Slug_Sprite.png"),
		"collision" : $SlugCollision,
		"scale" : 3
	},
	Type.GOBLIN : {
		"score" : 10,
		"sprite" : preload("res://Graphics/Goblin_Sprite.png"),
		"collision" : $GoblinCollision,
		"scale" : 4.5,
	},
	Type.ORC : {
		"score" : 12,
		"sprite" : preload("res://Graphics/Orc_Sprite.png"),
		"collision" : $OrcCollision,
		"scale" : 4.3
	},
	Type.MASK_ORC : {
		"score" : 14,
		"sprite" : preload("res://Graphics/Masked_Orc_Sprite.png"),
		"collision" : $MaskOrcCollision,
		"scale" : 5
	},
	Type.IMP : {
		"score" : 16,
		"sprite" : preload("res://Graphics/Imp_Sprite.png"),
		"collision" : $ImpCollision,
		"scale" : 5
	},
	Type.BIG_ZOMBIE : {
		"score" : 18,
		"sprite" : preload("res://Graphics/Big_Zombie_Sprite.png"),
		"collision" : $BigZombieCollision,
		"scale" : 3
	},
	Type.BIG_OGRE : {
		"score" : 20,
		"sprite" : preload("res://Graphics/Big_Ogre_Sprite.png"),
		"collision" : $BigOgreCollision,
		"scale" : 3.5
	},
	Type.BIG_DEMON : {
		"score" : 22,
		"sprite" : preload("res://Graphics/Big_Demon_Sprite.png"),
		"collision" : $BigDemonCollision,
		"scale" : 4
	}
}

#REMEMBER THAT BIG MONSTERS' SPRITES ARE TWICE THE SIZE OF THE REGULAR MONSTERS


@onready var sprite := $Sprite2D


#SOUNDS

var explosion_sound = preload("res://Sound/boom3.wav")

#EDITBLE OUTSIDE OF SCOPE

@export var deathParticle : PackedScene
@export var type: int = Type.TINY_ZOMBIE 

#local


var scale_type = 1
var fusionned_bool := false
var currCollision

func _ready():
	pass


func set_type(monster_type):
	type = monster_type
	currCollision = MONSTER_INFO[type]["collision"]
	sprite.texture = MONSTER_INFO[type]["sprite"]
	scale_type = MONSTER_INFO[type]["scale"]
	currCollision.set_deferred("disabled", false)
	

func set_size():
	sprite.scale *= scale_type
	currCollision.scale *= scale_type
	
func get_type_sprite() -> Object:
	return MONSTER_INFO[type]["sprite"]
	

func get_monster_scale():
	return MONSTER_INFO[type]["scale"]

func get_score():
	return MONSTER_INFO[type]["score"]


func _on_body_entered(body):
	#script is different than monster script (eg, wall)
	if body.get_script() != get_script():
		return
	if body.type != type:
		return
	if body.name > name:
		return
	if fusionned_bool:
		return
	fusionned_bool = true
	
	emit_signal("fusionned", body, self)

#handle deletion of monster
func delete():
	#instantiate an explosion particle
	var particle = deathParticle.instantiate()
	particle.position = global_position
	particle.rotation = global_rotation
	if type < Type.BIG_DEMON:
		particle.scale *= scale_type
	else:
		particle.scale *= 0.5 * scale_type
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	AudioManager.play_sound(explosion_sound, -20.0)
	 
	#handle collision deletion
	max_contacts_reported = 0
	set_deferred("contact_monitor", false)
	currCollision.set_deferred("disabled", true)
	collision_mask = 0
	collision_layer = 0
	
	queue_free()
	

