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
onready var my_collision = $CollisionShape2D
onready var coy_timer = $CoyoteTimer
onready var pre_timer = $PreemptiveTimer
onready var sesame_spawn = $SesameSpawn

onready var baguette = $Baguette
onready var baguette_collision = $Baguette/CollisionShape2D
onready var baguette_timer = $Baguette/AttackTimer

const Sesame = preload("Projectile.tscn")

enum Weapon {
	TRADITION,
	SESAME,
	FRENCH
}

enum Side {
	LEFT,
	RIGHT
}

var side = Side.RIGHT
var weapon = Weapon.TRADITION
var attacking = false

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
			turn_right()
		elif input_vector.x < 0:
			turn_left()

	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	
	velocity = move_and_slide(velocity, Vector2.UP)

func set_animation(name):
	match weapon:
		Weapon.TRADITION:
			my_sprite.play("Tradition"+name)
		Weapon.SESAME:
			my_sprite.play("Sesame"+name)
		Weapon.FRENCH:
			my_sprite.play("French"+name)

func turn_right():
	my_sprite.scale.x = 1
	baguette.position.x = 10.5
	my_collision.position.x = -2.5
	sesame_spawn.position.x = 14
	side = Side.RIGHT
	
func turn_left():
	my_sprite.scale.x = -1
	baguette.position.x = -10.5
	my_collision.position.x = 2.5
	sesame_spawn.position.x = -14
	side = Side.LEFT

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		set_animation("Attack")
		baguette_collision.disabled = false
		if not attacking and weapon == Weapon.SESAME:
			var sesame = Sesame.instance()
			sesame.global_position = sesame_spawn.global_position
			var dirv = Vector2.ZERO
			if Input.is_action_pressed("ui_down"):
				dirv = Vector2(1,-1) if side == Side.RIGHT else Vector2(-1, -1)
			else:
				dirv = Vector2(0.25,-1) if side == Side.RIGHT else Vector2(-0.25, -1)
			sesame.velocity = dirv.normalized() * 400
			get_parent().add_child(sesame)
		attacking = true
	if event.is_action_pressed("test"):
		weapon = Weapon.SESAME
		set_animation("Idle")


func _on_AnimatedSprite_animation_finished():
	if attacking:
		set_animation("Idle")
		baguette_collision.disabled = true
		attacking = false
