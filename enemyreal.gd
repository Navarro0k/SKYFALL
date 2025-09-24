extends Node2D
# === VARIABLES EXPORTADAS (ajustables desde el editor) ===
@export var fire_rate: float = 1.2              # Tiempo entre disparos
@export var detect_range: float = 1200.0        # Rango de detección del jugador
@export var bullet_scene: PackedScene           # Escena de la bala (asignar en el editor o usa fallback)
@export var bullet_speed: float = 800.0         # Velocidad de la bala


# === VARIABLES INTERNAS ===
var player: Node = null
var active: bool = false
var fallback_path := "res://scenes/Bullet.tscn" # Ruta fallback para la bala

# =========================================================
func _ready() -> void:
	# 1) Buscar jugador en grupo "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		print("ADVERTENCIA: No encontré un nodo en el grupo 'player'.")

	# 2) Si no asignaste bullet_scene en el editor, intento fallback
	if bullet_scene == null:
		if ResourceLoader.exists(fallback_path):
			bullet_scene = load(fallback_path)
			print("Info: bullet_scene no asignado. Usando fallback:", fallback_path)
		else:
			printerr("ERROR: bullet_scene no asignado y fallback no existe en", fallback_path)

	# 3) Conectar VisibilityNotifier2D si existe
	var visibility = get_node_or_null("VisibilityNotifier2D")
	if visibility:
		visibility.connect("screen_entered", Callable(self, "_on_screen_entered"))
		visibility.connect("screen_exited", Callable(self, "_on_screen_exited"))
	else:
		print("ADVERTENCIA: No encontré 'VisibilityNotifier2D' como hijo.")

	# 4) Conectar Timer (FireTimer) si existe
	var fire_timer = get_node_or_null("FireTimer")
	if fire_timer:
		fire_timer.wait_time = fire_rate
		fire_timer.connect("timeout", Callable(self, "_on_firetimer_timeout"))
	else:
		print("ADVERTENCIA: No encontré Timer hijo 'FireTimer'.")

	# 5) Reproducir animación idle si el enemigo tiene animaciones
	var anim = get_node_or_null("AnimatedSprite2D")
	if anim and anim.sprite_frames and anim.sprite_frames.has_animation("idle"):
		anim.play("idle")

# =========================================================
func _on_screen_entered() -> void:
	active = true
	var fire_timer = get_node_or_null("FireTimer")
	if fire_timer: fire_timer.start()

	var anim = get_node_or_null("AnimatedSprite2D")
	if anim and anim.sprite_frames.has_animation("move"):
		anim.play("move")

# =========================================================
func _on_screen_exited() -> void:
	active = false
	var fire_timer = get_node_or_null("FireTimer")
	if fire_timer: fire_timer.stop()

	var anim = get_node_or_null("AnimatedSprite2D")
	if anim and anim.sprite_frames.has_animation("idle"):
		anim.play("idle")

# =========================================================
func _on_firetimer_timeout() -> void:
	if not active or player == null:
		return

	var dir = player.global_position - global_position
	if dir.length() > detect_range:
		return

	# Cambiar animación a "attack" si existe
	var anim = get_node_or_null("AnimatedSprite2D")
	if anim and anim.sprite_frames.has_animation("attack"):
		anim.play("attack")

	_fire(dir)

	# Volver a "move" o "idle"
	if anim:
		if anim.sprite_frames.has_animation("move"):
			anim.play("move")
		elif anim.sprite_frames.has_animation("idle"):
			anim.play("idle")

# =========================================================
func _fire(dir: Vector2) -> void:
	if bullet_scene == null:
		printerr("ERROR: No hay escena de bala asignada.")
		return

	var b = bullet_scene.instantiate()
	b.global_position = global_position

	if b.has_method("set_direction"):
		b.set_direction(dir)
	elif b.has_variable("velocity"):
		b.velocity = dir.normalized() * bullet_speed

	get_tree().current_scene.add_child(b)
