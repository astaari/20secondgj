extends MarginContainer

const TUTORIAL_UI = preload("uid://twfgvt5n33po")
const WIN_UI = preload("uid://bb0cimgdasd16")
const PAUSE_UI = preload("uid://duf8ki5xop28p")

const PERSON = preload("uid://bf7js5xmur06k")

@onready var spawn_node: Node2D = $"../SpawnNode"

#signal timeout

var GAME_TIME : float = 20.0

@onready
var timer_ui : Label = %GameTimer
var timer_node

const TUTORIAL = -1
const PLAY = 0
const GAMEOVER = 1
const PAUSE = 2
var state = TUTORIAL


### TODO Could be improved. Likely needs to be redone or states moved around.
func _ready() -> void:
	update_time_label()
	_spawn_gui("tutorialui")

func _start_game():
	timer_node = timer_ui.get_tree().create_timer(GAME_TIME).timeout.connect(_placehold_gameover)
	set_score(0)
	GameState.score_changed.connect(set_score)
	_spawn_person()
	state = PLAY

func _spawn_person():
	var inst = PERSON.instantiate()
	get_parent().call_deferred("add_child",inst)
	inst.global_position = spawn_node.position
	inst.startY = spawn_node.position.y
	inst.z_index = -1
	inst.game_manager = self

func update_time_label():
	#TODO: Put back as float when we get decimal
	timer_ui.text = "%d" % GAME_TIME

func _placehold_gameover():
	print("Game over")
	#Update game_ui
	GAME_TIME = 0.0
	state = GAMEOVER
	update_time_label()
	_spawn_gui("winui")
	
func _spawn_gui(_type):
	var inst = WIN_UI.instantiate()
	match _type:
		"winui": #Spawn in win_ui
			inst = WIN_UI.instantiate()
		"tutorialui":
			inst = TUTORIAL_UI.instantiate()
		"pauseui":
			inst = PAUSE_UI.instantiate()
	inst.size = inst.base_size
	inst.global_position = (global_position + size) / 2.0 - (inst.size/2.0)
	inst.game_manager = self
	get_parent().add_child.call_deferred(inst)
	
func _process(delta: float) -> void:
	if state == PLAY:
		GAME_TIME-=delta
		update_time_label()
		#Handle pause
		if Input.is_action_just_pressed("pause"):
			state = PAUSE
			_spawn_gui("pauseui")
	

func set_score(score : int ):
	%Score.text = "%d" % score
