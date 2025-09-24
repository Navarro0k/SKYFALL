extends CanvasLayer

var tiempo: float = 0.0

func _process(delta: float) -> void:
	tiempo += delta
	
	var minutos = int(tiempo) / 60
	var segundos = int(tiempo) % 60
	
	# %02d asegura que los segundos siempre tengan 2 dígitos (ej: 1:05, 2:09)
	$Label.text = str(minutos) + ":" + str("%02d" % segundos)
