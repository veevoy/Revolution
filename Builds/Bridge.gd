extends Area2D

onready var sprite = $AnimatedSprite
onready var closed_collision = $ClosedCollision
onready var open_collision = $OpenStaticBody/OpenCollision
onready var invisible_wall_collision = $InvisibleWall/InvisibleWallCollision
var open = false

func _on_Bridge_area_entered(area):
	if not open and "hit_owner" in area and area.hit_owner == "sesame":
		sprite.play("Open")
		open = true
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
		set_collision_layer_bit(3, false)
		closed_collision.set_deferred("disabled", true)
		invisible_wall_collision.set_deferred("disabled", true)
		open_collision.set_deferred("disabled", false)

