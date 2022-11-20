extends Area2D

export var type_of_upgrade = ""

const MAX_SPEED = 25
const FRICTION = 100
var velocity = Vector2.UP * MAX_SPEED

enum Side {UP, DOWN}
var side = Side.UP

func _physics_process(delta):
	velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
	if velocity.y == 0:
		match side:
			Side.UP:
				side = Side.DOWN
				velocity = Vector2.DOWN * MAX_SPEED
			Side.DOWN:
				side = Side.UP
				velocity = Vector2.UP * MAX_SPEED
	global_position = global_position + velocity*delta




func _on_FloatingLoot_body_entered(body):
	if body.has_method("loot"):
		body.loot(type_of_upgrade)
		queue_free()
