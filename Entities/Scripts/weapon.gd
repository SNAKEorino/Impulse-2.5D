extends ProgressBar
@export var meter : ProgressBar
@export var body : Node

	
func _physics_process(delta):
	meter.value = body.get('energy')
	
