extends KinematicBody2D

# Script by Veevoy

const GRAVITY = 15
const MAX_SPEED = 150
const ACCELERATION = 500
const JUMP_IMPULSE = -250
const FRICTION = 2000

var input_vector = Vector2()
var velocity = Vector2()

onready var my_sprite = $AnimatedSprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	velocity.y += GRAVITY


#	if input_vector != Vector2.ZERO:
#		velocity.x = move_toward(velocity.x, input_vector.x * MAX_SPEED, ACCELERATION * delta)
#
#		if input_vector.x > 0:
#			my_sprite.scale.x = 1
#			baguette.position.x = 8
#			baguette_sprite.scale.x = 1
#		elif input_vector.x < 0:
#			my_sprite.scale.x = -1
#			baguette.position.x = -8
#			baguette_sprite.scale.x = -1
#
#	else:
#		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	
	velocity = move_and_slide(velocity, Vector2.UP)

