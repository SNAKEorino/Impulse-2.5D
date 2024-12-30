extends TileMap
@export var respawndestructible : Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	set_layer_modulate(1, 0)
	Signalbus._target_down.connect(_destroywall)

func _destroywall(target):
	if target == 1:
		set_layer_enabled(2, false)
		respawndestructible.start()


func _on_respawn_destructible_timeout():
	set_layer_enabled(2, true)
