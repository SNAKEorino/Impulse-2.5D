extends Node

class_name CharaStateMachine

@export var current_state : State
@export var character : CharacterBody3D
@export var hitstun : Timer
@export var hit_state : State
@export var crouch_state : State
@export var slide_state : State
@export var ground_state : State
@export var air_state : State
@export var groundboost_state : State
@export var airboost_state : State
@export var homingattack_state : State
@export var omniboost_state : State
@export var playerdamage : Node

var states : Array[State]

func _ready():
	Signalbus._got_hit.connect(got_hit)
	for child in get_children():
		if (child is State):
			states.append(child)
			child.character = character
#			#set the states up with what they need to function
			
		else:
			push_warning("Child" + child.name + " should not be in State Machine.")

func _physics_process(delta):
	#if a new next state is set, process tye change
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
	current_state.state_process(delta)
	

func check_can_move():
	#checks movement
	return current_state.can_move

func switch_states(new_state : State):
	#function that changes states
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
		##makes sure when reentering old state that next state is cleared to stop constant switch
	
	current_state = new_state
	current_state.on_enter()
	

func _input(event : InputEvent):
	#ensures that inputs are managed by the correct state
	current_state.state_input(event)
	
func got_hit(knockback_direction):
	hitstun.start()
	current_state.next_state = hit_state 
