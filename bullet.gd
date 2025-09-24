# Bullet.gd (Godot 4)
extends Area2D

@export var speed: float = 700.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	$VisibilityNotifier2D.connect("screen_exited", Callable(self, "queue_free"))
	$LifeTimer.connect("timeout", Callable(self, "queue_free"))

func _physics_process(delta: float) -> void:
	position += velocity * delta

func set_direction(dir: Vector2) -> void:
	velocity = dir.normalized() * speed
	rotation = velocity.angle()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)  # o ajustá el daño
	queue_free()
