extends Node
class_name Damageable

@export var charaBody : CharacterBody3D
@export var charaModel : MeshInstance3D
var knockbacktween

func hit(damage : float):
	charaBody.health -= damage
	#knockbacktween = get_tree().create_tween()
	#knockbacktween.tween_property(charaModel, 'modulate', Color(1, 1, 1, 1), 0.3)		
	if(charaBody.health <= 0):
		Signalbus.emit_signal('_grantenergy', 2)
		Signalbus.emit_signal('_energyChange')
		get_parent().queue_free()
		
