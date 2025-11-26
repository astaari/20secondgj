extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const RETURN = 0

var move_with_mouse = false
var state = 0

var rw = 1152.0
var leftrw = (rw*2)/8
var midrw = rw/2
var rightrw = (rw*6)/8
var startY

func _ready():
	startY = position.y

func _process(_delta):
	if move_with_mouse:
		#Move position
		global_position = lerp(global_position,get_global_mouse_position(),0.2)
	else:
		match state:
			RETURN: #Return to the center of the screen
				self.position = lerp(self.position, Vector2(midrw, startY), 0.25)

#Finalizes the players choice based on the cards x position
func _on_selector_button_up() -> void:
	if global_position.x > rightrw:
		print("Right!")
	elif global_position.x < leftrw:
		print("Left!")
	else:
		state = RETURN
	move_with_mouse = false

#Selects the card to be moved
func _on_selector_button_down() -> void:
	move_with_mouse = true
