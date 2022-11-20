extends KinematicBody2D

const GRAVITY = 15
const FRICTION = 10

onready var my_sprite = $AnimatedSprite
onready var explosion_collision = $ExplosionHurtbox/CollisionShape2D
onready var explosion_timer = $ExplosionTimer

var velocity = Vector2.ZERO

signal exploded

func set_type(new_type):
	if new_type == "single":
		my_sprite.play("Single")
		explosion_collision.set_deferred("radius", 30)
	elif new_type == "french":
		my_sprite.play("French")
		explosion_collision.set_deferred("radius", 50)

func _physics_process(delta):
	velocity.y += GRAVITY
	if FRICTION > 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_FuseTimer_timeout():
	explosion_collision.set_deferred("disabled", false)
	explosion_timer.start()
	my_sprite.visible = false

func _on_ExplosionTimer_timeout():
	emit_signal("exploded")
	queue_free()
