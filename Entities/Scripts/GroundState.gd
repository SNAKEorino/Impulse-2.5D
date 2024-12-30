extends State

class_name GroundState
@export var air_state :State
@export var groundBoost_state :State
@export var jump_anim : String = 'jump'
@export var hit_state : State
@export var homingattack_state : State
@export var crouch_state : State
@export var slide_state : State
@export var hitstun : Timer
@export var bouncetimer : Timer
var crouching = false
#@export var animplayer : AnimationPlayer
@export var jumpcollis : Area3D
@export var boostcollis : Area3D
var jump_buffer = 0.0
var can_jump = true
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@onready var jump_velocity: float = (((2.0 * jump_height) / jump_time_to_peak) ) 
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) 
@export var bounce_height : float
@export var bounce_time_to_peak : float
@export var bounce_time_to_descent : float
@onready var bounce_velocity: float = (((2.0 * bounce_height) / bounce_time_to_peak))
@export var crouchjump_height : float
@export var crouchjump_time_to_peak : float
@export var crouchjump_time_to_descent : float
@onready var crouchjump_velocity: float = (((2.0 * crouchjump_height) / crouchjump_time_to_peak))



func _ready():
	Signalbus._stompbounce.connect(bounce)
	Signalbus._crouchJump.connect(crouchjump)

func _physics_process(delta):
	if(Input.is_action_just_pressed("jump") and can_jump == true):
		if crouching == false:
			jump()
		elif crouching == true:
			crouchjump()
		Signalbus.emit_signal('_jumping')
	elif (Input.is_action_just_released("jump") and can_jump == true):
		character.velocity.y = lerp(character.velocity.y, 0.0, 0.4)
		can_jump = false
	if(character.is_on_floor()):
		can_jump = true
		groundBoost_state.boostdir = null
		crouching = false
		Signalbus.emit_signal('_grounded')
	
	

func state_input(event : InputEvent):
	if(Input.is_action_just_pressed('dash') && character.energy  > 0):
		character.energy -= 7.5
		character.canchangedir = false
		next_state = groundBoost_state
	if(Input.is_action_just_pressed("homingattack") and character.can_homing_attack == true):
		if character.seektarget != null:
			character.boosting = false
			character.can_homing_attack = false
			next_state = homingattack_state
	if(Input.is_action_just_pressed('slide')):
		if character.direction.x == 0:
			crouching = true
			next_state = crouch_state
		else:
			crouching = true
			next_state = slide_state
	
func state_process(delta):
	#boostfx.visible = false
	character.boosting = false;
	character.canchangedir = true
	character.is_stomping = false
	character.can_homing_attack = true
	boostcollis.damage = 0
	jumpcollis.damage = 0
	#handle decceleration out of a boost
	if (character.facing == 'right'):
		if (character.velocity.x > 50 and not Input.is_action_pressed("dash")):
			boostcollis.damage = 0
			character.velocity.x -= 1
	elif (character.facing == 'left'):
		if (character.velocity.x < -50 and not Input.is_action_pressed("dash")):
			boostcollis.damage = 0
			character.velocity.x += 1
	if (character.velocity.x > 0 and not Input.is_action_pressed("dash")):
		if Input.is_action_pressed("left"):
			character.velocity.x -= 5
	elif (character.velocity.x < 0 and not Input.is_action_pressed("dash")):
		if Input.is_action_pressed("right"):
			character.velocity.x += 5
	if(not character.is_on_floor()):
		next_state = air_state
		

func jump():
	can_jump = false
	character.velocity.y = jump_velocity

func crouchjump():
	can_jump = false
	character.velocity.y = crouchjump_velocity

func bounce():
	character.velocity.y = bounce_velocity

func get_gravity():
	return jump_gravity if character.velocity.y < 0.0 else fall_gravity

	
	
