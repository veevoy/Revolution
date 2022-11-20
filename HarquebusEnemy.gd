extends KinematicBody2D

# Script by Veevoy

const GRAVITY = 15
const MAX_SPEED = 10
const ACCELERATION = 500
const JUMP_IMPULSE = -250
const FRICTION = 2000

var input_vector = Vector2()
var velocity = Vector2()

var health = 2

onready var my_sprite = $AnimatedSprite
onready var my_raycast = $RayCast2D
onready var my_collision = $CollisionShape2D
onready var detection_area = $DetectionZone
onready var bullet_timer = $BulletTimer
onready var bullet_spawn = $BulletSpawn
onready var hurtbox = $Hurtbox

const Bullet = preload("Bullet.tscn")

enum Side {
	LEFT = -1,
	RIGHT = 1
}

var side = Side.RIGHT
var int_side = 1
var attacking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not my_raycast.is_colliding():
		int_side = -int_side
	velocity.y += GRAVITY
	velocity.x = move_toward(velocity.x, int_side * MAX_SPEED, ACCELERATION * delta)
	
	if int_side > 0:
		turn(Side.RIGHT)
	elif int_side < 0:
		turn(Side.LEFT)
	
	velocity = move_and_slide(velocity, Vector2.UP)

	for area in detection_area.get_overlapping_areas():
		if "hb_owner" in area and area.hb_owner == "player":
			if bullet_timer.is_stopped():
				my_sprite.play("Attack")
				bullet_timer.start()
				shoot()
				attacking = true

func turn(new_side):
	if side != new_side:
		my_sprite.scale.x = -my_sprite.scale.x
		my_raycast.position.x = -my_raycast.position.x
		my_collision.position.x = -my_collision.position.x
		hurtbox.position.x = -hurtbox.position.x
		detection_area.position.x = -detection_area.position.x
		bullet_spawn.position.x = -bullet_spawn.position.x
		side = new_side

func shoot():
	var bullet = Bullet.instance()
	var dirv = Vector2.ZERO
	dirv = Vector2.RIGHT if side == Side.RIGHT else Vector2.LEFT
	bullet.config(
		"bullet",
		bullet_spawn.global_position,
		dirv.normalized() * 350,
		0,
		0
	)
	get_parent().add_child(bullet)

func _on_Hurtbox_area_entered(area):
	if health > 0:
		health -= 1
	else:
		queue_free()


func _on_AnimatedSprite_animation_finished():
	if attacking:
		attacking = false
		my_sprite.play("Walk")
