extends Camera3D

var rotate = false
@export var cam : Camera3D
var cameraScale = 0.0
var xnum = 10.0
var ynum = 5.0
var znum = 20.0
#camera volume test

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#
	#cam.set_rotation_degrees(Vector3(0, cameraScale, 0))
	#cam.set_position(Vector3(xnum, ynum, znum))
	#if (rotate == true):
		#cameraScale = lerp(cameraScale, -60.0, 0.01)
		#xnum = lerp(xnum, -5.0, 0.01)
		#ynum = lerp(ynum, 3.0, 0.01)
		#znum = lerp(znum, 6.0, 0.01)
	#else:
		#cam.set_rotation_degrees(Vector3(0, 0, 0))
#
#func _on_rotate_volume_timeout() -> void:
	#rotate = true
