extends Node2D

const PERSON = preload("uid://bf7js5xmur06k")

#TODO Might need to move some logic into a parent object so some game state is 
# not coupled with person (example, correct vs incorrect)


#NOTE: Temp, should probably create a resource to encapsulate - artifex
enum TYPE{HUMAN=0,GOBLIN=1,VAMPIRE=2};

@onready var sprite_2d: Sprite2D = $Sprite2D

const RETURN = 0
const THROWLEFT = 1
const THROWRIGHT = 2
const NOTHING = 3

var move_with_mouse = false
var state = 3

var rw = 1152.0
var leftrw = (rw*2)/8
var midrw = rw/2
var rightrw = (rw*6)/8
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
	$Sprite2D.modulate=color;
			
	
			
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
	elif moving:
		return
	else:
		match state:
			NOTHING:
				return	#do nothing
			RETURN: #Return to the center of the screen
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
					print("dead")
					state = RETURN;
					var inst = PERSON.instantiate()
					#make sure it gets added after this one is freed
					get_parent().call_deferred("add_child",inst)
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
