extends Node2D

onready var music = $Music
onready var boss_music = $BossMusic
onready var boss_wall_sprite = $BossWall/BossWallSprite
onready var boss_wall_collision = $BossWall/BossWallCollision

var boss_playing = false



func _on_ChgMusic_area_entered(area):
	print("hello")
	if not boss_playing:
		music.stop()
		boss_music.play()
		boss_playing = true
		boss_wall_sprite.visible = true
		boss_wall_collision.set_deferred("disabled", false)
