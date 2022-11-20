extends KinematicBody2D

const GRAVITY = 15
const FRICTION = 10

onready var my_sprite = $AnimatedSprite
onready var explosion = $ExplosionHitbox
onready var explosion_collision = $ExplosionHitbox/CollisionShape2D
onready var explosion_timer = $ExplosionTimer
onready var explosion_sprite = $ExplosionHitbox/AnimatedSprite

var velocity = Vector2.ZERO
var exploding = false
var is_french = false

signal exploded

func set_type(new_type):
	if new_type == "french":
		my_sprite.play("French")
		explosion_collision.shape.set_deferred("radius", 50)
		explosion.hit_owner = "french_dynamite"
		is_french = true

func _physics_process(delta):
	velocity.y += GRAVITY
	if FRICTION > 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_FuseTimer_timeout():
	explosion_collision.set_deferred("disabled", false)
	if is_french:
		explosion_sprite.play("French")
	else:
		explosion_sprite.play("Single")
	my_sprite.visible = false
	exploding = true

func _on_AnimatedSprite_animation_finished():
	if exploding:
		emit_signal("exploded")
		queue_free()
		exploding = false
