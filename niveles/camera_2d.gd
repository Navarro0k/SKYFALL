extends Camera2D

@export var objet_seguir :Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = objet_seguir.position
	pass
