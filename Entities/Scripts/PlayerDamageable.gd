extends Node
class_name PDamageable
@export var body : CharacterBody3D
@export var phealth : float = 10
var will_stagger = false
var is_damageable = true
var enemydirection = 'left'
@export var hitstun : Timer
@export var invincibility : Timer
@export var hit_state : State
@export var charamodel : MeshInstance3D
var starttimer = true
var knockbacktween

func enemy_direction(direction):
	enemydirection = direction

func hit(damage : float, knockback_direction : Vector2):
	if (is_damageable == true):
		is_damageable = false
		if starttimer == true:
			starttimer = false
			invincibility.start()
		Signalbus.emit_signal('_got_hit', knockback_direction)
		knockbacktween = get_tree().create_tween()
		will_stagger = true
		phealth -= damage
		if(phealth <= 0):
			get_tree().reload_current_scene()

func fell(damage : float):
	if (is_damageable == true):
		Signalbus.emit_signal('_fell')
		is_damageable = false
		will_stagger = false
		phealth -= damage
		if(phealth <= 0):
			get_tree().reload_current_scene()
		await hitstun.timeout
		is_damageable = true

func _on_invincibility_timer_timeout() -> void:
	is_damageable = true
	starttimer = true
