class_name Personaje
extends CharacterBody2D
@onready var jump_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var gravity = 1500
@export var jump_speed = 700
@export var speed = 400
@export var max_jumps = 2   # máximo número de saltos

var jumps_done: int = 0     # cuántos saltos llevamos

func _physics_process(delta: float) -> void:
	var direccion = Input.get_axis("Izquierda", "derecha")
	velocity.x = speed * direccion

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# al tocar el suelo, reseteamos el contador
		jumps_done = 0

	# Salto / Doble salto
	if Input.is_action_just_pressed("saltar") and jumps_done < max_jumps:
		velocity.y = -jump_speed
		jumps_done += 1
		jump_sound.play()
	move_and_slide()
