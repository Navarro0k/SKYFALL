extends CharacterBody2D

var bullet_velocity: Vector2 = Vector2.ZERO
@export var damage: int = 1
var shooter: Node = null   # referencia al que disparó

func _physics_process(delta):
	velocity = bullet_velocity
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()

		# Debug para saber con qué choca
		print("Bala colisionó con: ", collider.name)

		# Ignorar al dueño
		if collider == shooter:
			print("Colisión ignorada con el dueño: ", shooter.name)
			return

		# Si puede recibir daño
		if collider and collider.has_method("take_damage"):
			print("Le hago daño a: ", collider.name)
			collider.take_damage(damage)

		# Se destruye tras colisión válida
		print("Bala destruida tras colisión con: ", collider.name)
		queue_free()

# 🔹 Este método lo dispara automáticamente el VisibleOnScreenNotifier2D
func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Bala realmente salió de la pantalla, se destruye")
	queue_free()
