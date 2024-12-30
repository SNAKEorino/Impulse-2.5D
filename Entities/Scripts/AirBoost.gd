extends State
class_name AirBoostState
var ascent = 10
@export var ground_state : State
@export var air_state : State
@export var stomp_state : State
@export var homingattack_state : State
#@export var animplayer : AnimationPlayer
@export var boostcollis : Area3D 
@export var airboosttimer : Timer
@export var airBoostMinDur : Timer

func state_process(delta):
	character.can_wall_jump = true
	character.is_stomping = false
	if (character.energy > 0):
		character.boosting = true;
		airdash();
		boostcollis.damage = 3;
		ascent -= 0.5
	else:
		reset()
		airboosttimer.stop()
		next_state = air_state;
	if(character.is_on_floor()):
		reset()
		airboosttimer.stop()
		next_state = ground_state;

func airdash():
	if (character.facing == 'right'):
		character.velocity.x = 100
		character.velocity.y = ascent
	elif (character.facing == 'left'):
		character.velocity.x = -100
		character.velocity.y = ascent

func state_input(event : InputEvent):
	if(Input.is_action_just_released(('dash'))):
		reset()
		airboosttimer.stop()
		next_state = air_state
	if(Input.is_action_just_pressed("stomp")):
		air_state.can_stomp = false
		reset()
		airboosttimer.stop()
		next_state = stomp_state
	if(Input.is_action_just_pressed("jump") or character.is_on_wall()):
		reset()
		airboosttimer.stop()
		next_state = air_state
	if(Input.is_action_just_pressed("homingattack") and character.can_homing_attack == true):
		if character.seektarget != null:
			reset()
			airboosttimer.stop()
			character.boosting = false
			character.can_homing_attack = false
			next_state = homingattack_state

func _on_airboostduration_timeout():
	reset()
	next_state = air_state

func reset():
	character.canchangedir = true
	ascent = 5
	airBoostMinDur.start()
