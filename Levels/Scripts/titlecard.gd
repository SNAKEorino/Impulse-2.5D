extends Label
var positionchange := Vector2.ZERO
var positioncheck := Vector2.ZERO
var reversepositioncheck := Vector2.ZERO
var startimer = true
@export var titletimer : Timer

func _ready():
	positionchange = 200 * Vector2.RIGHT.rotated(rotation)
	positioncheck = -7000 * Vector2.RIGHT.rotated(rotation)
	reversepositioncheck = -10000 * Vector2.RIGHT.rotated(rotation)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position <= positioncheck:
		position += positionchange
	elif startimer == true:
		titletimer.start()
		startimer = false


func _on_titletimer_timeout():
	queue_free()
