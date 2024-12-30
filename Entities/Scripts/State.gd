extends Node
class_name State

@export var can_move : bool = true

var character : CharacterBody3D
var next_state : State
var playback : AnimationNodeStateMachinePlayback

#base state node is from where all further states extend and so is the source of shared functions
#and variables
#nothing happens here it's just the source for everything
func state_process(delta):
	pass
func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
