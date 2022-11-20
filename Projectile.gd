extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(int) var bullet_gravity = 15
export(int) var bullet_friction = 10
export var hit_owner = ""
export var damage = 1

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func config(new_global_position : Vector2, new_velocity : Vector2) -> void:
	global_position = new_global_position
	velocity = new_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += bullet_gravity
	if bullet_friction > 0:
		velocity.x = move_toward(velocity.x, 0, bullet_friction * delta)
	global_position = global_position + velocity*delta

func _on_Projectile_area_entered(_area):
	queue_free()

func _on_Projectile_body_entered(_body):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
