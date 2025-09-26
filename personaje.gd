class_name Personaje
extends CharacterBody2D

@onready var jump_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var gravity = 1400
@export var jump_speed = 500
@export var speed = 250
@export var max_jumps = 2  

@onready var animated_sprite = $"sprite animado"
var jumps_done: int = 0    
var is_facing_right = true

@export var max_vida: int = 6
var vida: int

# Referencia al HUD (ajusta el nombre si tu raíz cambia)
@onready var hud = get_tree().root.get_node("SKYMAP level/HUD")

func _ready() -> void:
	add_to_group("player")
	vida = max_vida
	if hud:
		hud.update_vida(vida, max_vida)

func take_damage(amount: int) -> void:
	vida -= amount
	if hud:
		hud.update_vida(vida, max_vida)

	# efecto de daño visual
	$"sprite animado".modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.15).timeout
	$"sprite animado".modulate = Color(1, 1, 1)

	if vida <= 0:
		die()

func die() -> void:
	get_tree().reload_current_scene()

# ------------------------
# Movimiento y animaciones
# ------------------------
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_done = 0
	
	flip()
	move_x()
	jump()
	update_animations()

	move_and_slide()

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		return
		
	if velocity.x != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("Idle")
			
func move_x():
	var direccion = Input.get_axis("Izquierda", "derecha")
	velocity.x = speed * direccion

func flip(): 
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right
	
func jump():
	if Input.is_action_just_pressed("saltar") and jumps_done < max_jumps:
		velocity.y = -jump_speed
		jumps_done += 1
		jump_sound.play()
