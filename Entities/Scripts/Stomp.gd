extends State
class_name StompState

@export var ground_state : State
@export var air_state : State
@export var jumpcollis : Area3D

func state_process(delta):
	character.can_wall_jump = true
	character.is_stomping = true
	if Input.is_action_pressed("slide"):
		character.velocity.x = 0
	if character.velocity.y < 640:
		character.velocity.y -= 20
	if(character.is_on_floor() and not Input.is_action_pressed("stomp")):
		air_state.can_stomp = true
		jumpcollis.damage = 3
		next_state = ground_state
	elif(character.is_on_floor() and Input.is_action_pressed("stomp")):
		air_state.can_stomp = true
		Signalbus.emit_signal('_stompbounce')
		jumpcollis.damage = 3
		next_state = ground_state
