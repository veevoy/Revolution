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
onready var coy_timer = $CoyoteTimer
onready var pre_timer = $PreemptiveTimer

func check_jump(impulse, prev_velocity):
	if Input.is_action_just_pressed("ui_up"): # or is_on_wall() to add wall jumps
		pre_timer.start()
	if (not coy_timer.is_stopped()) and (not pre_timer.is_stopped()):
		pre_timer.stop()
		coy_timer.stop()
		return impulse
	return prev_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if is_on_floor():
		coy_timer.start()

	velocity.y += GRAVITY
	velocity.y = check_jump(JUMP_IMPULSE, velocity.y)

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, input_vector.x * MAX_SPEED, ACCELERATION * delta)
		
		if input_vector.x > 0:
			my_sprite.scale.x = 1
		elif input_vector.x < 0:
			my_sprite.scale.x = -1

	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	
	velocity = move_and_slide(velocity, Vector2.UP)


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		print("attack")
