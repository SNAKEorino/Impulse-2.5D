extends Area2D
class_name softcheckpoint
@export var selftimer : Timer
var airborne = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus._initiaterespawn.connect(sendposition)
	Signalbus.connect('_airborne', checkair)
	Signalbus.connect('_grounded', checkgrounded)

func _on_checkpoint_timer_timeout():
	if (airborne == false):
		queue_free()
	elif (airborne == true):
		selftimer.start()

func sendposition():
	var softpointposition = $Marker2D.global_position
	Signalbus.emit_signal('_setsoftcheckpointposition', softpointposition)

func checkair():
	airborne = true
func checkgrounded():
	airborne = false
