extends CharacterBody3D


@export var speed : int = 7
@export var turn : Timer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
var facing = 'left'
var health : float = 1
var damage : float = 1

func _ready():
	add_to_group("targets")
	direction.x = -1

func _physics_process(delta):
	move_and_slide()
	velocity.x = direction.x * speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	if (direction.x == -1):
		facing == 'left'
	elif (direction.x == 1):
		facing == 'right'

func _on_turn_timeout():
	direction.x *= -1
