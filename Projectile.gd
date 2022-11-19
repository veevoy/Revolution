extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const GRAVITY = 15
const FRICTION = 10

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	global_position = global_position + velocity*delta


func _on_Projectile_area_entered(area):
	queue_free()

func _on_Projectile_body_entered(body):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
