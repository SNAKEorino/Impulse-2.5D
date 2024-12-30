extends State
class_name HomingAttackState

@export var damageable : Node
@export var ground_state : State
@export var air_state : State
@export var homing_attack_cooldown : Timer
@export var homing_attack_speed = 10
@export var boostcollis : Area3D
@export var jumpcollis : Area3D
var targetsHit = 0
@export var postAttackBoostLockout : Timer

func state_process(delta):
	character.can_wall_jump = true
	character.is_stomping = false
	damageable.is_damageable = true
	jumpcollis.damage = 0
	boostcollis.damage = 0
	if character.seektarget != null:
		character.canchangedir = false
		homing_attack_cooldown.start()
		character.velocity.x = 0
		var direction = (character.seektarget.global_position - character.global_position	).normalized()
		if homing_attack_speed < 200:
			homing_attack_speed += homing_attack_speed
		var attackspeed = direction * homing_attack_speed
		if character.global_position.distance_to(character.seektarget.global_position) > 4:
			character.velocity = attackspeed
		else:
			if character.seektarget.health == 1:
				character.energy +=2
				Signalbus.emit_signal('_energyChange')
				jump()
				if not Input.is_action_pressed("homingattack"):
					reset()
				character.seektarget.queue_free()
	else:
		reset()
func jump():
	Signalbus.emit_signal('_enemybounce', 'enemy')
	postAttackBoostLockout.start()
	
func reset():
	character.velocity.x = 0
	homing_attack_speed = 25
	targetsHit = 0
	air_state.can_doublejump = false
	air_state.can_airboost = false
	character.canchangedir = true
	damageable.is_damageable = true
	next_state = air_state


func _on_post_attack_boost_lockout_timeout() -> void:
	air_state.can_doublejump = true
	air_state.can_airboost = true
