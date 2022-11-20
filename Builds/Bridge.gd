extends Area2D

# the script is the same for the elevator and the bridge
# script by Veevoy

onready var sprite = $AnimatedSprite
onready var trigger_collision = $TriggerCollision
onready var open_collision = $OpenStaticBody/OpenCollision
onready var closed_collision = $ClosedStaticBody/ClosedCollision

onready var sfx_triggered = $SFXTriggered

var open = false

func _on_Bridge_area_entered(area):
	if not open and "hit_owner" in area and area.hit_owner == "sesame":
		open = true
		sprite.play("Open")
		sfx_triggered.play()
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
		set_collision_layer_bit(3, false)
		trigger_collision.set_deferred("disabled", true)
		closed_collision.set_deferred("disabled", true)
		open_collision.set_deferred("disabled", false)
