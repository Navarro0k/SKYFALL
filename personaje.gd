class_name Personaje
extends CharacterBody2D
@onready var jump_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var gravity = 1400
@export var jump_speed = 700
@export var speed = 400
@export var max_jumps = 2   # máximo número de saltos

@onready var animated_sprite = $"sprite animado"
var jumps_done: int = 0     # cuántos saltos llevamos
var is_facing_right =true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_done = 0
	flip()
	move_x()
	jump(delta)
	update_animations()

	move_and_slide()

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		return
		
	if velocity.x:
		animated_sprite.play("run")
	else:
		animated_sprite.play("Idle")
			
		

func move_x():
	var direccion = Input.get_axis("Izquierda", "derecha")
	velocity.x = speed * direccion

func flip(): 
	if(is_facing_right and velocity.x<0) or (not is_facing_right and velocity.x>0):
		scale.x *=-1
		is_facing_right = not is_facing_right
	
func jump(delta):
		# Salto / Doble salto
	if Input.is_action_just_pressed("saltar") and jumps_done < max_jumps:
		velocity.y = -jump_speed
		jumps_done += 1
		jump_sound.play()
