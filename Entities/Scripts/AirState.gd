extends State

class_name AirState
@export var ground_state : State
@export var groundBoost_state : State
@export var airboost_state : State
@export var stomp_state : State
@export var homingattack_state : State
@export var omnidash_state : State
@export var wall_state : State
#@export var animplayer : AnimationPlayer
@export var boostcollis : Area3D
@export var jumpcollis : Area3D
@export var airboosttimer : Timer
var can_doublejump =  true
var can_airboost = true
var can_omni = true
var can_stomp = true
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@onready var jump_velocity: float = (((2.0 * jump_height) / jump_time_to_peak) ) 
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) 
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) 
@export var postAttackBoostLockout : Timer
@export var airBoostMinDur : Timer
@export var hitStopKindaTimer : Timer
@export var omniTimer : Timer

func _ready():
	Signalbus._enemybounce.connect(doublejump)

func _physics_process(delta):
	if(character.is_on_floor()):
		ground_state.can_jump = true
		can_doublejump =  true
		can_omni = true
		can_airboost = true
		character.can_wall_jump = true
	if(Input.is_action_just_pressed("jump") and ground_state.can_jump == false and can_doublejump == true and character.freeze == false):
		doublejump('jump')
		character.can_wall_jump = true
		can_doublejump = false

func state_process(delta):
	character.is_stomping = false
	if (character.velocity.x > 0 and not Input.is_action_pressed("dash")):
		character.boosting = false
		boostcollis.damage = 0
		character.canchangedir = false
		if Input.is_action_pressed("left"):
			character.velocity.x -= 3
	elif (Input.is_action_pressed("dash") and postAttackBoostLockout.time_left == 0):
		#boostcollis.damage = 3
		character.boosting = true;
		character.canchangedir = false
	elif (character.velocity.x < 0 and not Input.is_action_pressed("dash")):
		character.boosting = false
		boostcollis.damage = 0
		character.canchangedir = false
		if Input.is_action_pressed("right"):
			character.velocity.x += 3
	elif (Input.is_action_pressed("dash") and postAttackBoostLockout.time_left == 0):
		boostcollis.damage = 3
		character.boosting = true;
		character.canchangedir = false
	else:
		boostcollis.damage = 0
		character.boosting = false;
		character.canchangedir = true
	jumpcollis.damage = 3
	#animplayer.play('jump')
	if(character.direction.x == 0 and not Input.is_action_pressed("dash") and airBoostMinDur.time_left == 0 and character.can_wall_jump == true):
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.3)
	if(character.is_on_floor() and Input.is_action_pressed("dash") and character.energy > 0 and can_doublejump ==  false):
		next_state = groundBoost_state
	elif character.is_on_floor():
		next_state = ground_state
	if(Input.is_action_just_pressed("stomp")):
		can_stomp = false
		next_state = stomp_state
	if character.is_on_wall():
		pass
		#next_state = wall_state

func state_input(event : InputEvent):
	if(Input.is_action_just_pressed(('dash')) and can_airboost == true and character.energy > 0 and character.can_homing_attack == true):
		airboosttimer.start()
		can_airboost = false
		character.canchangedir = false
		character.energy -= 7.5
		next_state = airboost_state
	if(Input.is_action_just_pressed("homingattack") and character.can_homing_attack == true):
		if character.seektarget != null:
			character.boosting = false
			character.can_homing_attack = false
			next_state = homingattack_state
	if(Input.is_action_just_pressed("trick right") or Input.is_action_just_pressed("trick left") or Input.is_action_just_pressed("trick launch") and can_omni == true):
		if Input.is_action_just_pressed("trick right"):
			omnidash_state.type = 'right'
		if Input.is_action_just_pressed("trick left"):
			omnidash_state.type = 'left'
		elif Input.is_action_just_pressed("trick launch"):
			omnidash_state.type = 'up'
		if can_omni == true:
			character.velocity.y = 0
			character.velocity.x = 0
			hitStopKindaTimer.start()
			can_omni = false

func doublejump(type):
	if type == 'enemy':
		if character.is_stomping == false:
			character.velocity.y = jump_velocity *  1.3
	elif type == 'jump':
		character.velocity.y = jump_velocity


func _on_hit_stop_kinda_timer_timeout() -> void:
	omniTimer.start()
	next_state = omnidash_state
