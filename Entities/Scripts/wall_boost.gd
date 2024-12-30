extends State

class_name WallBoostState

@export var ground_state : State
@export var wall_state : State
@export var air_state : State
@export var stomp_state : State
@export var homingattack_state : State
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@onready var jump_velocity: float = (((2.0 * jump_height) / jump_time_to_peak)) 
var can_wall_jump = true
@export var wallJumpTimeout : Timer

func state_process(delta):
	character.freeze = true
	#character.charaModel.set_rotation(Vector3(0, 0, 1.571))
	#character.bodyCollision.set_rotation(Vector3(0, 0, 1.571))
	##character.boost_fx.set_rotation(Vector3(0, 0, -1.571))
	#character.jumpArea.set_rotation(Vector3(0, 0, 1.571))
	#character.boostArea.set_rotation(Vector3(0, 0, 1.571))
	if(character.is_on_floor()):
		character.freeze = false
		reset()
		next_state = ground_state
	if(not character.is_on_wall()):
		character.velocity.y = lerp(character.velocity.y, 0.0, 0.6)
		if wallJumpTimeout.time_left == 0 and character.is_on_floor() == false:
			character.freeze = false
			reset()
			next_state = air_state
	if character.is_on_wall() == true and character.is_on_floor() == false:
		can_wall_jump = true
		if character.get_wall_normal().x > 0: #left side wall
			character.velocity.x = -10
		if character.get_wall_normal().x < 0: #right side wall
			character.velocity.x = 10
		character.velocity.y = 75
		

func state_input(event : InputEvent):
	#watch safe margin, was used here to fix wall jump inconsisties, might cause issues later
	if(Input.is_action_just_released(('dash'))):
		reset()
		next_state = wall_state
	if character.get_wall_normal().x > 0: #left side wall
		if Input.is_action_pressed("right"): #wall dismount
			character.freeze = false
			wallJumpTimeout.stop()
			character.velocity.x = 5
			reset()
			next_state = air_state
		if(Input.is_action_just_pressed("jump") and can_wall_jump == true): #wall jump
			wallJumpTimeout.stop()
			wallJumpTimeout.start()
			character.velocity.y += jump_velocity
			character.velocity.x = 75
			can_wall_jump = false
			print('fsdg')
			character.facing = 'right'
	if character.get_wall_normal().x < 0: #right side wall
		if Input.is_action_pressed("left"): #wall dismount
			character.freeze = false
			wallJumpTimeout.stop()
			character.velocity.x = -5
			reset()
			next_state = air_state
		if(Input.is_action_just_pressed("jump") and can_wall_jump == true): #wall jump
			wallJumpTimeout.start()
			character.velocity.y += jump_velocity
			character.velocity.x = -75
			can_wall_jump = false
			character.facing = 'left'
	if(Input.is_action_just_pressed("homingattack") and character.can_homing_attack == true):
		if character.seektarget != null:
			character.can_homing_attack = false
			reset()
			next_state = homingattack_state
			
func reset():
	pass
	#character.charaModel.set_rotation(Vector3(0, 0, 1.0))
	#character.bodyCollision.set_rotation(Vector3(0, 0, 0))
	##character.boost_fx.set_rotation(Vector3(0, 0, -1.571))
	#character.jumpArea.set_rotation(Vector3(0, 0, 0))
	#character.boostArea.set_rotation(Vector3(0, 0, 0))
