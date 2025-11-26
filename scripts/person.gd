extends Node2D

const PERSON = preload("uid://bf7js5xmur06k")
@onready var sprite_2d: Sprite2D = $Sprite2D

const RETURN = 0
const THROWLEFT = 1
const THROWRIGHT = 2

var move_with_mouse = false
var state = 0

var rw = 1152.0
var leftrw = (rw*2)/8
var midrw = rw/2
var rightrw = (rw*6)/8
var startY

# Q: Do we want to use this throw script or maybe we just use buttons? 

func _ready():
	startY = position.y

func _process(_delta):
	if move_with_mouse:
		#Move position
		global_position = lerp(global_position,get_global_mouse_position(),0.2)
	else:
		match state:
			RETURN: #Return to the center of the screen
				position = lerp(position, Vector2(midrw, startY), 0.2)
			THROWLEFT: 
				position = lerp(position, Vector2(-500.0, startY),0.05)
				if position.x < -200.0:
					_die()
			THROWRIGHT: 
				position = lerp(position, Vector2(rw+500.0, startY),0.05)
				if position.x > rw+200.0:
					_die()

func _die():
					print("dead")
					var inst = PERSON.instantiate()
					get_parent().add_child(inst)
					inst.global_position = Vector2(midrw,startY)
					inst.startY = startY
					inst.z_index = -1
					queue_free()
	

#Finalizes the players choice based on the cards x position
func _on_selector_button_up() -> void:
	if global_position.x > rightrw:
		print("Right!")
		state = THROWRIGHT
	elif global_position.x < leftrw:
		print("Left!")
		state = THROWLEFT
	else:
		state = RETURN
	move_with_mouse = false

#Selects the card to be moved
func _on_selector_button_down() -> void:
	move_with_mouse = true
