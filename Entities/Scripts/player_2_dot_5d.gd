extends CharacterBody3D
class_name player

@export var player : CharacterBody3D
@export var damagecheck : Node
@export var groundstate : Node
#@export var animplayer : AnimationPlayer
@export var charaModel : MeshInstance3D
@export var debugArrow : MeshInstance3D
@export var boost_fx : MeshInstance3D
@export var jumpArea : Area3D
@export var boostArea : Area3D
@export var bodyCollision : CollisionShape3D
var candash = true
var canchangedir = true
var facing = 'right'
var boosting = false
var jumping = false
var energy = 100
var regainrate = 0.2
@export var energycooldown : Timer
@export var homingreticle : Sprite3D
@export var state_machine : CharaStateMachine
@export var ray : RayCast3D
var recoverEnergy = false
var direction : Vector2 = Vector2.ZERO
var previous_normal = Vector3.UP
@export var homing_attack_range = 300
var is_stomping = false
var can_homing_attack = true
var seektarget: Node3D = null
var freeze = false
var can_wall_jump = true


func _ready():
	Signalbus._grantenergy.connect(addenergy)
	Signalbus._setsoftcheckpointposition.connect(respawn) 
	Signalbus._energyChange.connect(reset_energy_cooldown)

func _physics_process(delta):
	#movement
	velocity.z = 0
	if (energy > 100): #caps energy
		energy = 100
	move_and_slide() #ensures physics
	if not is_on_floor(): #sets gravity
			velocity.y += groundstate.get_gravity() * delta
	if is_on_floor():
		velocity.y = 0
	if ray.is_colliding():
		#var priorNormal = Vector3.UP
		var newNormal = ray.get_collision_normal()
		var angle = Vector3.UP.signed_angle_to(newNormal, Vector3.BACK)
		charaModel.set_rotation(Vector3(0, 0, angle))
		ray.set_rotation(Vector3(0, 0, angle))
		bodyCollision.set_rotation(Vector3(0, 0, angle))
		#velocity = from_to_rotation(priorNormal, newNormal) * velocity;
		#priorNormal = newNormal
		print(angle)
		velocity = velocity.rotated(Vector3.UP.normalized(), angle)
		debugArrow.look_at(velocity)
	#elif angle != null:
		#velocity = velocity.rotated(Vector3.BACK.normalized(), angle)
	if state_machine.check_can_move() == true and freeze == false: 
		direction = Input.get_vector("left", "right", "up",  "down")	
		move()
	if (boosting == true):
		damagecheck.is_damageable = false
		energycooldown.stop()
		boost_fx.visible = true
		recoverEnergy = false
		energy -= 0.1;
	elif (boosting == false):
		damagecheck.is_damageable = true
		boost_fx.visible = false
		if (recoverEnergy == false and energycooldown.time_left == 0):
			energycooldown.start()
	if (recoverEnergy == true):
		regainrate += 0.01
		if (energy < 100):
			energy += regainrate
	#update_animation()
	find_target()
	update_direction()
	
#func from_to_rotation(from: Vector3, to: Vector3) -> Quaternion:
	#if from.is_equal_approx(to):
		#return Quaternion.IDENTITY
	#var axis = from.cross(to)
	#var angle = from.angle_to(to)
	#if is_zero_approx(angle) or axis.is_zero_approx():
		#return Quaternion.IDENTITY
	#return Quaternion(axis.normalized(), angle)


func move():
	if direction.x > 0 and boosting == false:
		if velocity.x < 50:
			velocity.x += 0.75
	elif direction.x < 0 and boosting == false:
		if velocity.x > -50:
			velocity.x -= 0.75
	elif direction.x == 0 and boosting == false and is_on_floor() == true:
		velocity.x = lerp(velocity.x, 0.0, 0.3)
	Signalbus.emit_signal('_moving')

func update_animation():
	if (is_on_floor()) && direction.x == 0 and not boosting == true:
		$AnimationPlayer.play('Idle')
	if (is_on_floor()) && (not direction.x == 0 or boosting == true):
		$AnimationPlayer.play('run')

func update_direction():
	if direction.x > 0 and canchangedir == true:
		#sprite.flip_h = false
		facing = 'right'
		#checkpoint_position.scale.x = 1
	elif direction.x < 0 and canchangedir == true:
		#sprite.flip_h = true
		#sprite.position.x = -50
		facing = 'left'
		#checkpoint_position.scale.x = -1
	if facing == 'right':
		boost_fx.set_rotation_degrees(Vector3(0, 0, -90))
		boost_fx.position.x = 1
	elif facing == 'left':
		boost_fx.set_rotation_degrees(Vector3(0, 0, 90))
		boost_fx.position.x = -1



func find_target():
	seektarget = null
	var closest_distance = homing_attack_range
	for targetobject in get_tree().get_nodes_in_group('targets'):
		var distance = global_position.distance_to(targetobject.global_position)
		if distance <= closest_distance:
			closest_distance = distance
			seektarget = targetobject
	if seektarget != null:
		homingreticle.visible = true
		homingreticle.global_position = seektarget.global_position + Vector3(0, 0, 1)
		if position.distance_to(seektarget.global_position) > homing_attack_range:
			seektarget = null
		if facing == 'right':
			if self.position.x >= seektarget.position.x:
				closest_distance = homing_attack_range
				seektarget = null
		elif facing == 'left':
			if self.position.x <= seektarget.position.x:
				closest_distance = homing_attack_range
				seektarget = null
	elif seektarget == null:
		homingreticle.visible = false

func _on_homingattackcooldown_timeout():
	can_homing_attack = true

func reset_energy_cooldown():
	regainrate = 0.2
	recoverEnergy = false
	energycooldown.start()

func _on_energy_cooldown_timeout():
	regainrate = 0.2
	recoverEnergy = true
	
func subtractenergy(cost):
	energy -= cost
	
func addenergy(amount):
	energy += amount

func _on_pitdetect_body_entered(body):
	if(body is DeathPlane):
		if(damagecheck.phealth >= 1):
			damagecheck.fell(2)
			Signalbus.emit_signal('_initiaterespawn')

func respawn(position):
	self.position = position
