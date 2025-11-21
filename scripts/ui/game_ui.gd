extends MarginContainer

const WIN_UI = preload("uid://bb0cimgdasd16")

#signal timeout

var GAME_TIME : float = 20.0

@onready
var timer_ui : Label = %GameTimer
var timer_node

const PLAY = 0
const GAMEOVER = 1
var state = PLAY

### TODO Could be improved. Likely needs to be redone or states moved around.
func _ready() -> void:
	timer_node = timer_ui.get_tree().create_timer(GAME_TIME).timeout.connect(_placehold_gameover)
	
	pass

func _placehold_gameover():
	print("Game over")
	#Spawn in win_ui
	var inst = WIN_UI.instantiate()
	get_parent().add_child(inst)
	inst.size = inst.base_size
	inst.global_position = (global_position + size) / 2.0 - (inst.size/2.0)
	#Update game_ui too
	GAME_TIME = 0.0
	timer_ui.text = "%.2f" % GAME_TIME
	state = GAMEOVER
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == PLAY:
		GAME_TIME-=delta
		timer_ui.text = "%.2f" % GAME_TIME
	
	
