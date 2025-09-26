extends CharacterBody2D

@export var move_speed: float = 200
@export var bala: PackedScene = preload("res://Bala.tscn")

var is_facing_right: bool = true
var move_target: Vector2 = Vector2.ZERO
var moving: bool = false
var is_attacking: bool = false

@onready var animated_sprite: AnimatedSprite2D = $Animatedsprite

func _ready():
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(_delta):
	if Input.is_action_just_pressed("move_mouse"):
		move_target = get_global_mouse_position()
		moving = true
	if Input.is_action_just_pressed("Disparo") and not is_attacking:
		shoot()

	move_xy()
	flip()
	update_animations()
	move_and_slide()

func move_xy():
	if moving:
		var direction = (move_target - global_position).normalized()
		velocity = direction * move_speed
		if global_position.distance_to(move_target) < 5:
			velocity = Vector2.ZERO
			moving = false
	else:
		velocity = Vector2.ZERO

func flip():
	if velocity.x > 0 and not is_facing_right:
		scale.x = abs(scale.x)
		is_facing_right = true
	elif velocity.x < 0 and is_facing_right:
		scale.x = -abs(scale.x)
		is_facing_right = false

func update_animations():
	if is_attacking:
		animated_sprite.play("Attack")
	elif velocity.length() > 1:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

func shoot():
	var bullet = bala.instantiate()
	get_parent().add_child(bullet)

	var mouse_pos = get_global_mouse_position()
	var direction_x = mouse_pos.x - global_position.x
	var direction = Vector2(direction_x, 0).normalized()

	bullet.global_position = Vector2(global_position.x, global_position.y)
	bullet.bullet_velocity = direction * 400
	bullet.shooter = self

	is_attacking = true
	animated_sprite.play("Attack")

func _on_animation_finished(anim_name = ""):
	if anim_name == "" or anim_name == "Attack":
		is_attacking = false
