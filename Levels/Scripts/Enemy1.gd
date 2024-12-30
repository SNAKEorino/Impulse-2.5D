extends Area2D

@export var damage : float = 1

func _on_body_entered(body):
	for child in body.get_children():
		if(child is PDamageable):
			child.hit(damage)
			
