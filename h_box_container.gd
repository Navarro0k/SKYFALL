extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@export var corazon_lleno: Texture2D
@export var corazon_vacio: Texture2D
@export var max_corazones: int = 5

var corazones = []

func _ready_():
	# Crear los corazones al iniciar
	for i in range(max_corazones):
		var sprite = TextureRect.new()
		sprite.texture = corazon_lleno
		sprite.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		add_child(sprite)
		corazones.append(sprite)

func actualizar_vida(vida_actual: int):
	for i in range(max_corazones):
		if i < vida_actual:
			corazones[i].texture = corazon_lleno
		else:
			corazones[i].texture = corazon_vacio
