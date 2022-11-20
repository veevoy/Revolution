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
onready var french_laser_spawn = $FrenchLaserSpawn

onready var baguette = $Baguette
onready var baguette_collision = $Baguette/CollisionShape2D
onready var hurtbox = $Hurtbox

onready var sfx_swing = $Swing
onready var sfx_sesame = $SesameUpgrade
onready var sfx_french = $FrenchUpgrade
onready var sfx_hit = $Hit
onready var sfx_death = $Death

const Sesame = preload("res://Sesame.tscn")
const Dynamite = preload("res://Dynamite.tscn")
const FrenchLaser = preload("res://FrenchLaser.tscn")

enum Weapon {
	TRADITION,
	SESAME,
	FRENCH
}

enum DynamiteType {
	NONE,
	SINGLE,
	FRENCH
}

enum Side {
	LEFT,
	RIGHT
}

var side = Side.RIGHT
var weapon = Weapon.TRADITION
var dynamite_type = DynamiteType.NONE
var attacking = false
var dynamite_thrown = false

func check_jump(impulse, prev_velocity):
	if Input.is_action_just_pressed("jump"): # or is_on_wall() to add wall jumps
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

	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, input_vector.x * MAX_SPEED, ACCELERATION * delta)
		
		if input_vector.x > 0:
			turn(Side.RIGHT)
		elif input_vector.x < 0:
			turn(Side.LEFT)
			
		if not attacking:
			set_animation("Walk")

	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
		if velocity.x == 0 and not attacking: 
			set_animation("Idle")

	
	velocity = move_and_slide(velocity, Vector2.UP)

func set_animation(name):
	match weapon:
		Weapon.TRADITION:
			my_sprite.play("Tradition"+name)
		Weapon.SESAME:
			my_sprite.play("Sesame"+name)
		Weapon.FRENCH:
			my_sprite.play("French"+name)

func turn(new_side):
	if side != new_side:
		my_sprite.scale.x = -my_sprite.scale.x
		baguette.position.x = -baguette.position.x
		hurtbox.position.x = -hurtbox.position.x
		my_collision.position.x = -my_collision.position.x 
		sesame_spawn.position.x = -sesame_spawn.position.x
		french_laser_spawn.position.x = -french_laser_spawn.position.x
		side = new_side
		match side:
			Side.LEFT:
				position.x -= 7
			Side.RIGHT:
				position.x += 7

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		set_animation("Attack")
		baguette_collision.disabled = false
		if not attacking:
			sfx_swing.play()
			if weapon == Weapon.SESAME or weapon == Weapon.FRENCH:
				var sesame = Sesame.instance()

				var dirv = Vector2.ZERO
				if Input.is_action_pressed("down"):
					dirv = Vector2(1,-1) if side == Side.RIGHT else Vector2(-1, -1)
				else:
					dirv = Vector2(0.25,-1) if side == Side.RIGHT else Vector2(-0.25, -1)

				sesame.config(sesame_spawn.global_position, dirv.normalized() * 400)

				get_parent().add_child(sesame)
			if weapon == Weapon.FRENCH:
				var french_laser = FrenchLaser.instance()

				var dirv = Vector2(1, 0) if side == Side.RIGHT else Vector2(-1, 0)
				french_laser.config(french_laser_spawn.global_position, dirv.normalized() * 400)

				get_parent().add_child(french_laser)
		attacking = true
	
	if event.is_action_pressed("test"):
		weapon = Weapon.SESAME
		set_animation("Idle")
	
	if event.is_action_pressed("dynamite") and dynamite_type != DynamiteType.NONE and not dynamite_thrown:
		dynamite_thrown = true
		var dynamite = Dynamite.instance()
		match dynamite_type:
			DynamiteType.SINGLE:
				dynamite.call_deferred("set_type", "single")
			DynamiteType.FRENCH:
				dynamite.call_deferred("set_type", "french")
		dynamite.global_position = global_position
		dynamite.connect("exploded", self, "_on_Dynamite_exploded")
		get_parent().add_child(dynamite)

func _on_AnimatedSprite_animation_finished():
	if attacking:
		set_animation("Idle")
		baguette_collision.disabled = true
		attacking = false

func _on_Hurtbox_area_entered(area):
	if "damage" in area and area.damage > 0:
		sfx_hit.play()
		print("OUCH")

func _on_Dynamite_exploded():
	dynamite_thrown = false

func loot(type_of_upgrade):
	match type_of_upgrade:
		"baguette_sesame":
			weapon = Weapon.SESAME
			set_animation("Idle")
			sfx_sesame.play()
		"baguette_french":
			weapon = Weapon.FRENCH
			baguette.damage = 3
			set_animation("Idle")
			sfx_french.play()
		"dynamite_single":
			dynamite_type = DynamiteType.SINGLE
		"dynamite_french":
			dynamite_type = DynamiteType.FRENCH
