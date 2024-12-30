extends State

@export var charaModel : MeshInstance3D
@export var charaCollision : CollisionShape3D
@export var ground_state : State
@export var crouch_state : State
@export var air_state : State
@export var slide_state : State
@export var groundboost_state : State
var slowFactor = 0.2

func state_input(event : InputEvent):
	if Input.is_action_just_released("slide"):
		reset()
		next_state = groundboost_state
	if character.velocity.x == 0:
		reset()
		next_state = crouch_state
	#moving slide
	#if character.velocity.x != 0 and character.boosting == false:
		#character.velocity.x = lerp(character.velocity.x, 0.0, 0.1)
	#slide jump
	if Input.is_action_pressed("jump"):
		reset()
		Signalbus.emit_signal('_crouchJump')
		next_state = air_state
	if Input.is_action_just_released("dash"):
		reset()
		character.boosting = false
		next_state = slide_state
	
func state_process(delta):
	character.can_wall_jump = true
	ground_state.crouching = true
	charaModel.rotation_degrees = Vector3(0, 0, -90)
	charaCollision.rotation_degrees = Vector3(0, 0, -90)
	
func reset():
	charaModel.rotation_degrees = Vector3(0, 0, 0)
	charaCollision.rotation_degrees = Vector3(0, 0, 0)
