extends Node2D

onready var music = $Music
onready var boss_music = $BossMusic
onready var boss_wall_sprite = $BossWall/BossWallSprite
onready var boss_wall_collision = $BossWall/BossWallCollision
onready var reload_timer = $ReloadTimer

var boss_playing = false
var finished_updated = false


func _on_ChgMusic_area_entered(area):
	print("hello")
	if not boss_playing:
		music.stop()
		boss_music.play()
		boss_playing = true
		boss_wall_sprite.visible = true
		boss_wall_collision.set_deferred("disabled", false)

func _process(delta):
	if Global.finished and not finished_updated:
		if Global.win:
			music.play()
			boss_music.stop()
			reload_timer.start()
		else:
			music.stop()
			boss_music.stop()
			reload_timer.start()
		finished_updated = true


func _on_ReloadTimer_timeout():
	Global.restore_values()
	get_tree().reload_current_scene()
