extends StaticBody2D

export var vulnerability = "single_dynamite"

onready var simple_sprite = $SimpleSprite
onready var french_sprite = $FrenchSprite

func _ready():
	if vulnerability == "french_dynamite":
		simple_sprite.visible = false
		french_sprite.visible = true

func _on_Hurtbox_area_entered(area):
	print(area, area.hit_owner)
	if "hit_owner" in area and (area.hit_owner == vulnerability or (area.hit_owner == "french_dynamite" and vulnerability == "single_dynamite")):
		queue_free()
