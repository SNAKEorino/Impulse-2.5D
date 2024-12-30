extends State

class_name GroundBoostState
@export var ground_state : State
@export var air_state : State
@export var homingattack_state : State
@export var slideboost_state : State
#@export var animplayer : AnimationPlayer
@export var boostcollis : Area3D
var boostdir  = null
var jump_buffer = 0.0
var can_jump = true
@warning_ignore("unused_parameter")

func state_process(delta):
	character.is_stomping = false
	if (character.energy > 0):
		dash();
		character.boosting = true
		character.canchangedir = false
		boostcollis.damage = 3;
		if(not character.is_on_floor()):
			next_state = air_state;
		if(character.is_on_wall()):
			boostdir = null;
			character.canchangedir = true
			next_state = ground_state
	else:
		boostdir = null;
		character.canchangedir = true
		next_state = ground_state

func dash():
	if (character.facing == 'right'):
		boostdir = "right";
		character.velocity.x = 125
	elif ((character.facing == 'left')):
		boostdir = "left";
		character.velocity.x = -125

func state_input(event : InputEvent):
	if((Input.is_action_just_released(('dash')) or not Input.is_action_pressed("dash")) && character.is_on_floor()):
		boostdir = null;
		character.canchangedir = true
		next_state = ground_state
	if(Input.is_action_just_pressed("homingattack") and character.can_homing_attack == true):
		if character.seektarget != null:
			character.boosting = false
			character.can_homing_attack = false
			character.canchangedir = true
			next_state = homingattack_state
	if (Input.is_action_just_pressed("slide")):
		next_state = slideboost_state
		
