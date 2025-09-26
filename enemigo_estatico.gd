extends CharacterBody2D

@export var bala: PackedScene = preload("res://Bala.tscn")
@export var shoot_interval: float = 1.5
@export_enum("frontal", "doble", "en_angulo", "hacia_objetivo") var shoot_pattern: String = "frontal"
@export var bullet_speed: float = 400.0
@export var spawn_offset: float = 32.0
@export var aim_to_target: bool = true
@export var facing_right: bool = true

var is_attacking: bool = false
var shoot_timer: float = 0.0
var target: Node2D = null   # 🔹 se asignará automáticamente al Player

@onready var animated_sprite: AnimatedSprite2D = $Animatedsprite

func _ready():
	shoot_timer = shoot_interval
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

	# 🔹 Buscar al jugador automáticamente
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0] as Node2D

	# Ajustar dirección inicial
	if not facing_right:
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)

func _physics_process(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_interval

	update_animations()

func update_animations():
	if is_attacking:
		animated_sprite.play("Attack")
	else:
		animated_sprite.play("Idle")

func shoot():
	is_attacking = true

	if shoot_pattern == "hacia_objetivo" and aim_to_target and target:
		var target_pos = target.global_position
		var dir = (target_pos - global_position).normalized()
		if dir.length() == 0:
			dir = get_facing_direction()
		_spawn_bullet(dir)
	else:
		match shoot_pattern:
			"frontal":
				_spawn_bullet(get_facing_direction())
			"doble":
				_spawn_bullet(Vector2.RIGHT)
				_spawn_bullet(Vector2.LEFT)
			"en_angulo":
				var base_dir = get_facing_direction()
				_spawn_bullet((base_dir + Vector2(0, -0.3)).normalized())
				_spawn_bullet((base_dir + Vector2(0, 0.3)).normalized())
			"hacia_objetivo":
				_spawn_bullet(get_facing_direction())

	animated_sprite.play("Attack")

func _spawn_bullet(direction: Vector2):
	if direction.length() == 0:
		direction = get_facing_direction()
	var bullet = bala.instantiate()
	get_parent().add_child(bullet)

	bullet.global_position = global_position + direction.normalized() * spawn_offset
	bullet.bullet_velocity = direction.normalized() * bullet_speed
	bullet.shooter = self

	if bullet is Node2D:
		# Rotar la bala según la dirección
		bullet.rotation = direction.angle()

		# 🔹 Invertir sprite de la bala si dispara hacia la izquierda
		if direction.x < 0:
			bullet.scale.x = -abs(bullet.scale.x)
		else:
			bullet.scale.x = abs(bullet.scale.x)

func get_facing_direction() -> Vector2:
	# Corregido: ahora dispara hacia el mismo lado que mira la animación
	return Vector2.LEFT if facing_right else Vector2.RIGHT

func _on_animation_finished(anim_name = ""):
	if anim_name == "" or anim_name == "Attack":
		is_attacking = false
