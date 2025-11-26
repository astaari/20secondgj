extends Node2D

const PERSON = preload("uid://bf7js5xmur06k")

const HAPPY = preload("uid://dpbgplj5jmgqq")
const NEUTRAL = preload("uid://dh0rrexx37iqc")
const SAD = preload("uid://d2catoh7titvt")

#TODO Might need to move some logic into a parent object so some game state is 
# not coupled with person (example, correct vs incorrect)


#NOTE: Temp, should probably create a resource to encapsulate - artifex
enum TYPE{HUMAN=0,GOBLIN=1,VAMPIRE=2};

@onready var sprite_2d: Sprite2D = $Body
@onready var face: Sprite2D = $Face


const RETURN = 0
const THROWLEFT = 1
const THROWRIGHT = 2
const NOTHING = 3

var move_with_mouse = false
var state = 3

var game_manager

var rw = 1152.0
var leftrw = (rw*3)/8
var midrw = rw/2
var rightrw = (rw*5)/8
var startY

const TWEEN_TIME : float = 0.2
var moving : bool = false
var type : TYPE 

# Q: Do we want to use this throw script or maybe we just use buttons? 

func _ready():
	startY = position.y
	type = (randi()%3) as TYPE
	
	#NOTE: artifex - This is temporary to visually distinguish type
	var color = Color.WHITE;
	match type:
		TYPE.HUMAN:
			color = Color.RED;
		TYPE.GOBLIN:
			color = Color.GREEN;
	sprite_2d.modulate=color;
	face.modulate=color;
	face.texture = NEUTRAL
	print("Type:",type)



func _unhandled_input(event: InputEvent) -> void:
	if not move_with_mouse or not moving:
		if event.is_action("move_left"):
			state=THROWLEFT
		elif event.is_action("move_right"):
			state=THROWRIGHT

#NOTE: artifex - Needed to edit this a bit so the score would work properly
#A good use case for tweens anyway.
func _process(_delta):
	if move_with_mouse:
		#Move position
		global_position = lerp(global_position,get_global_mouse_position(),0.2)
		#Update rotation
		var rot = (global_position.x / 750) - 0.8
		self.rotation = lerp_angle(self.rotation,rot,0.1)
		#Change facial emotion
		if position.x > rightrw:
			face.texture = SAD
		elif position.x > leftrw:
			face.texture = NEUTRAL
		else:
			face.texture = HAPPY
	elif moving:
		return
	else:
		match state:
			NOTHING:
				#Update rotation
				self.rotation = lerp_angle(self.rotation,0.0,0.1)
			RETURN: #Return to the center of the screen
				#Update the rest of it
				moving = true
				var end_position =Vector2(midrw, startY)
				(
				get_tree()
				.create_tween()
				.tween_property(self,"position",end_position,TWEEN_TIME).finished.connect(
					#on tween end, just set moving to false
					func():moving=false
					)
				)
				state=NOTHING
			THROWLEFT:
				moving = true
				var end_position = Vector2(-500.0, startY)
				(
				get_tree()
				.create_tween()
				.tween_property(self,"position",end_position,TWEEN_TIME).finished.connect(_die)
				)
				if type != TYPE.HUMAN:
					GameState.score +=1
				state = NOTHING

			THROWRIGHT: 
				moving = true
				var end_position = Vector2(rw+500.0, startY)
				(
				get_tree()
				.create_tween()
				.tween_property(self,"position",end_position,TWEEN_TIME).finished.connect(_die)
				)
				if type == TYPE.HUMAN:
					GameState.score +=1
				state = NOTHING


func _die():
	state = RETURN;
	game_manager._spawn_person()
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
