extends MarginContainer



@onready var spawn_node: Node2D = $"../SpawnNode"

signal game_over
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



func _ready() -> void:
	update_time_label()

func _start_game():
	timer_node = timer_ui.get_tree().create_timer(GAME_TIME).timeout.connect(_gameover)
	set_score(0)
	#GameState.score_changed.connect(set_score)


func set_banned_items(items : Array):
	var lbl = "BANNED:\n"
	for s in items:
		lbl+=s + "\n"
	%BannedLabel.text = lbl

func update_time_label():
	timer_ui.text = "%.2f" % GAME_TIME

func _gameover():
	print("Game over")
	GAME_TIME = 0.0
	state = GAMEOVER
	update_time_label()
	game_over.emit()
	

	
func _process(delta: float) -> void:
	if GAME_TIME > 0:
		GAME_TIME-=delta
		update_time_label()
	

func set_score(score : int ):
	%Score.text = "%d" % score
