extends Label
var time = 0
@export var stopwatch : Label

func _process(delta):
	time += delta
	var minutes = time/60
	var seconds = fmod(time, 60)
	var milliseconds = fmod(time, 1) * 100
	stopwatch.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
