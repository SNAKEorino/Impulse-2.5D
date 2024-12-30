extends State
class_name OmniBoostState

@export var ground_state : State
@export var air_state : State
#@export var animplayer : AnimationPlayer
@export var boostcollis : Area3D 
@export var dashtimer : Timer
@export var hitStopKindaTimer : Timer
var type = null

func state_process(delta):
	character.is_stomping = false
	if (character.energy > 0):
		if (type == 'left'):
			character.velocity.y = 0
			character.velocity.x = -100
		elif (type == 'right'):
			character.velocity.y = 0
			character.velocity.x = 100
		elif (type == 'up'):
			character.velocity.x = 0
			character.velocity.y = 40
	else:
		reset()
		next_state = air_state;
	if(character.is_on_floor()):
		reset()
		next_state = ground_state;
	if(character.is_on_wall()):
		reset()
		next_state = air_state

func reset():
	dashtimer.stop()
	character.canchangedir = true
	type = null

func dash():
	character.boosting = true;
	boostcollis.damage = 3;

func _on_dashtimer_timeout() -> void:
	reset()
	next_state = air_state
