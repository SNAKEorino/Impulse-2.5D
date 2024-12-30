extends State

@export var charaModel : MeshInstance3D
@export var charaCollision : CollisionShape3D
@export var ground_state : State
@export var slide_state : State
@export var air_state : State
@export var kickTimer : Timer

func state_input(event : InputEvent):
	if Input.is_action_just_released("slide"):
		reset()
		ground_state.crouching = false
		next_state = ground_state
	if Input.is_action_just_pressed('right'):
		reset()
		slide_state.kickDir = 'right'
		kickTimer.start()
		next_state = slide_state
	if Input.is_action_just_pressed('left'):
		reset()
		slide_state.kickDir = 'left'

		kickTimer.start()
		next_state = slide_state
	if Input.is_action_pressed("jump"):
		reset()
		ground_state.crouching = false
		Signalbus.emit_signal('_crouchJump')
		next_state = air_state
	
func state_process(delta):
	ground_state.crouching = true
	charaModel.scale.y = 0.5
	charaCollision.scale.y = 0.5
	
func reset():
	charaModel.scale.y = 1
	charaCollision.scale.y = 1
