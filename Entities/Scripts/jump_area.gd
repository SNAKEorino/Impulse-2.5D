extends Area3D
@export var damage : float = 3

func _on_body_entered(body):
	for child in body.get_children():
		if(child is Damageable and damage > 0):
			child.hit(damage)
			Signalbus.emit_signal('_enemybounce', 'enemy')
