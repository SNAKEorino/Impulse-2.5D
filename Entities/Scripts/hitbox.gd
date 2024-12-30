extends Area3D
@export var main_body : CharacterBody3D

func _on_body_entered(body):
	for child in body.get_children():
		if(child is PDamageable and child.is_damageable == true):
			var direction_to_player = (body.global_position - get_parent().global_position)
			var direction_sign = sign(direction_to_player.x)
			
			if direction_sign > 0:
				child.hit(main_body.damage, Vector2.RIGHT)
			elif direction_sign < 0:
				child.hit(main_body.damage, Vector2.LEFT)
			elif direction_sign == 0:
				child.hit(main_body.damage, Vector2.ZERO)
