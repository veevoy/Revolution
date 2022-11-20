extends KinematicBody2D

# Script by Veevoy

const GRAVITY = 15
const MAX_SPEED = 25
const ACCELERATION = 500
const JUMP_IMPULSE = -250
const FRICTION = 2000

var input_vector = Vector2()
var velocity = Vector2()

var health = 2

onready var my_sprite = $AnimatedSprite
onready var ground_raycast = $GroundRayCast
onready var wall_raycast = $WallRayCast
onready var my_collision = $CollisionShape2D
onready var sword = $Sword
onready var hitbox_collision = $Sword/CollisionShape2D
onready var detection_area = $DetectionZone
onready var response_timer = $ResponseTimer
onready var hurtbox = $Hurtbox

enum Side {
	LEFT = -1,
	RIGHT = 1
}

var side = Side.RIGHT
var int_side = 1
var need_attacking = false
var attacking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not ground_raycast.is_colliding() or wall_raycast.is_colliding() or velocity.x == 0:
		int_side = -int_side
	velocity.y += GRAVITY
	velocity.x = move_toward(velocity.x, int_side * MAX_SPEED, ACCELERATION * delta)
	
	if int_side > 0:
		turn(Side.RIGHT)
	elif int_side < 0:
		turn(Side.LEFT)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	need_attacking = false
	for area in detection_area.get_overlapping_areas():
		if "hurt_owner" in area and area.hurt_owner == "player":
			need_attacking = true
	
	if need_attacking and not attacking and response_timer.is_stopped():
		response_timer.start()

func turn(new_side):
	if side != new_side:
		my_sprite.scale.x = -my_sprite.scale.x
		ground_raycast.position.x = -ground_raycast.position.x
		wall_raycast.position.x = -wall_raycast.position.x
		my_collision.position.x = -my_collision.position.x
		sword.position.x = -sword.position.x
		hurtbox.position.x = -hurtbox.position.x
		detection_area.position.x = -detection_area.position.x
		side = new_side
		match side:
			Side.LEFT:
				position.x -= 6
			Side.RIGHT:
				position.x += 6

func _on_Hurtbox_area_entered(area):
	if health > 0:
		health -= 1
	else:
		queue_free()


func _on_AnimatedSprite_animation_finished():
	if attacking:
		hitbox_collision.disabled = true
		my_sprite.play("Walk")
		attacking = false


func _on_ResponseTime_timeout():
	hitbox_collision.disabled = false
	my_sprite.play("Attack")
	attacking = true
