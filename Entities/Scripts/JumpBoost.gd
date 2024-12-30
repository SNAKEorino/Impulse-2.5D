extends State
class_name JumpBoostState

@export var ground_state : State
@export var groundBoost_state : State
@export var animplayer : AnimationPlayer
@export var air_state : State
@export var stomp_state : State
var can_jump = true
@export var boostcollis : Area2D 


func state_process(delta):
	character.boosting = true;
	animplayer.play('jump')
	boostcollis.damage = 3
	if(Input.is_action_just_pressed("stomp")):
		character.velocity.x = 0
		character.boosting = false
		air_state.can_stomp = false
		next_state = stomp_state
	if(character.is_on_floor() and Input.is_action_pressed(('dash'))):
		next_state = groundBoost_state
	elif(character.is_on_floor() and not Input.is_action_pressed(('dash'))):
		groundBoost_state.boostdir = null;
		next_state = ground_state
	if(character.energy > 0):
		if (groundBoost_state.boostdir == "right"):
			character.velocity.x = 8000
		elif (groundBoost_state.boostdir == "left"):
			character.velocity.x = -8000
		if(character.is_on_wall()):
			groundBoost_state.boostdir = null;
			next_state = air_state;
	else:
		next_state = air_state;
		
func state_input(event : InputEvent):
	if(Input.is_action_just_released('dash') && not character.is_on_floor()):
		next_state = air_state;
	
	
 
