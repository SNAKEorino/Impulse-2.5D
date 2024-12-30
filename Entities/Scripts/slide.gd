extends State

@export var charaModel : MeshInstance3D
@export var charaCollision : CollisionShape3D
@export var ground_state : State
@export var crouch_state : State
@export var air_state : State
var kickDir = null
var kicking = false
var slowFactor = 0.2

func state_input(event : InputEvent):
	if Input.is_action_just_released("slide") and kicking == false:
		reset()
		next_state = ground_state
	#slide kick
	if character.velocity.x == 0 and kickDir != null:
		kicking = true
		if kickDir == 'right':
			character.velocity.x = 50
		if kickDir == 'left':
			character.velocity.x = -50
	elif character.velocity.x == 0 and kickDir == null:
		reset()
		next_state = crouch_state
	#moving slide
	if character.velocity.x != 0 and character.boosting == false:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.1)
	#slide jump
	if Input.is_action_pressed("jump"):
		reset()
		Signalbus.emit_signal('_crouchJump')
		next_state = air_state
	
func state_process(delta):
	character.can_wall_jump = true
	ground_state.crouching = true
	charaModel.rotation_degrees = Vector3(0, 0, -90)
	charaCollision.rotation_degrees = Vector3(0, 0, -90)
	
func reset():
	charaModel.rotation_degrees = Vector3(0, 0, 0)
	charaCollision.rotation_degrees = Vector3(0, 0, 0)


func _on_kick_timer_timeout() -> void:
	reset()
	kickDir = null
	kicking = false
	character.velocity.x = 0
	next_state = crouch_state
