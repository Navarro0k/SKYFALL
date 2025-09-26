extends CanvasLayer

var tiempo: float = 0.0

@onready var vida_label: Label = $VBoxContainer/Label2
@onready var cronometro_label: Label = $VBoxContainer/Label

func _process(delta: float) -> void:
	tiempo += delta
	
	var minutos = int(tiempo) / 60
	var segundos = int(tiempo) % 60
	
	cronometro_label.text = str(minutos) + ":" + str("%02d" % segundos)

func update_vida(actual: int, max: int) -> void:
	vida_label.text = "Vida: %d / %d" % [actual, max]
