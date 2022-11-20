extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hp = 3

onready var label = $Label
onready var lose = $Lose
onready var win = $Win

## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.hp != hp:
		hp = Global.hp
		label.text = "HP: %d/3" % [hp]
	
	if Global.finished:
		if Global.win:
			win.visible = true
			lose.visible = false
		else:
			win.visible = false
			lose.visible = true
