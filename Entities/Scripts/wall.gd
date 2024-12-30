extends State

class_name WallState

@export var ground_state : State
@export var wallboost_state : State
@export var air_state : State
@export var stomp_state : State
@export var homingattack_state : State
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@onready var jump_velocity: float = (((2.0 * jump_height) / jump_time_to_peak)) 
@export var wallJumpTimeout : Timer

func state_process(delta):
	character.freeze = true
	if(character.is_on_floor()):
		character.freeze = false
		character.can_wall_jump = true
		next_state = ground_state
	if(not character.is_on_wall()):
		if wallJumpTimeout.time_left == 0 and character.is_on_floor() == false:
			character.freeze = false
			character.can_wall_jump = true
			next_state = air_state
	if character.is_on_wall() == true and character.is_on_floor() == false:
		character.can_wall_jump = true
		character.velocity.x = 0
		character.velocity.y = -10
		

func state_input(event : InputEvent):
	#watch safe margin, was used here to fix wall jump inconsisties, might cause issues later
	if(Input.is_action_just_pressed(('dash'))):
		character.energy -= 3
		next_state = wallboost_state
	if character.get_wall_normal().x > 0: #left side wall
		if Input.is_action_pressed("right"): #wall dismount
			character.freeze = false
			wallJumpTimeout.stop()
			character.velocity.x = 5
			next_state = air_state
		if(Input.is_action_just_pressed("jump") and character.can_wall_jump == true): #wall jump
			wallJumpTimeout.stop()
			wallJumpTimeout.start()
			character.velocity.y = jump_velocity
			character.velocity.x = 75
			character.can_wall_jump = false
			character.facing = 'right'
	if character.get_wall_normal().x < 0: #right side wall
		if Input.is_action_pressed("left"): #wall dismount
			character.freeze = false
			wallJumpTimeout.stop()
			character.velocity.x = -5
			next_state = air_state
		if(Input.is_action_just_pressed("jump") and character.can_wall_jump == true): #wall jump
			wallJumpTimeout.start()
			character.velocity.y = jump_velocity
			character.velocity.x = -75
			character.can_wall_jump = false
			character.facing = 'left'
	if(Input.is_action_just_pressed("homingattack") and character.can_homing_attack == true):
		if character.seektarget != null:
			character.can_homing_attack = false
			character.can_wall_jump = true
			next_state = homingattack_state
