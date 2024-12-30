extends CharacterBody2D

@export var shot : PackedScene
@export var bposition : Marker2D
@export var shoottimer : Timer
var target : player
var health : float = 1
var damage : float = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
var facing = 'left'
var starttimer = true

func _ready():
	add_to_group("targets")
	direction.x = -1
	bposition.scale.x=1
	bposition.position.x = -385
	
func _physics_process(delta):
	if starttimer == true:
		shoottimer.start()
		starttimer = false
			
func shoot():
	var inst : enemyprojectile = shot.instantiate()
	owner.add_child(inst)
	inst.transform = get_node('strd_bullet_position').global_transform

func _on_shoot_timeout():
	shoot()
	starttimer = true
