extends State
class_name  HitState
var stagger = false
@export var hit : PDamageable
@export var ground_state : State
@export var hitstun : Timer
@export var enemycheck : PackedScene
@export var air_state : State
var setknockbackdir 

func _ready():
	Signalbus._got_hit.connect(got_hit)

func state_process(delta):
	character.can_wall_jump = true
	character.is_stomping = false
	if (stagger == true):
		character.velocity.x = 30 * setknockbackdir.x
	
func got_hit(knockback_direction : Vector2):
	setknockbackdir = knockback_direction
	hitstun.start()
	stagger = true

func _on_hitstun_timer_timeout() -> void:
	hit.will_stagger = false
	stagger = false
	if (character.is_on_floor() == true):
		next_state = ground_state
	elif (character.is_on_floor() == false):
		next_state = air_state
