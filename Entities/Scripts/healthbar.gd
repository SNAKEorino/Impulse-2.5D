extends ProgressBar
@export var meter : ProgressBar
@export var damage : Node

	
func _physics_process(delta):
	meter.value = damage.get('phealth')
	
