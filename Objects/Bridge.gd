extends Area2D

onready var sprite = $AnimatedSprite
onready var closed_collision = $ClosedCollision
onready var open_collision = $StaticBody2D/OpenCollision
var open = false

func _on_Bridge_area_entered(area):
	if not open and "type" in area and area.type == "sesame":
		sprite.play("Open")
		open = true
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
		set_collision_layer_bit(3, false)
		closed_collision.set_deferred("disabled", true)
		open_collision.set_deferred("disabled", false)

