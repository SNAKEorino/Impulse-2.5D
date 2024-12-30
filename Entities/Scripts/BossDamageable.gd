extends Node
class_name BossDamageable

@export var health : float = 20
@export var owndamage : float = 1

func hit(damage : float):
	health -= damage
	if(health <= 0):
		get_parent().queue_free()
		get_tree().change_scene_to_file("res://Levels/Scenes/endscreen.tscn")
		
