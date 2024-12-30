extends Label3D

@export var state_machine : CharaStateMachine
@export var chara : CharacterBody3D

func _process(delta):
	text = "State: " + state_machine.current_state.name + "\nFacing: " + chara.facing
