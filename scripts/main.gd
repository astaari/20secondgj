extends Node2D

const TUTORIAL_UI = preload("uid://twfgvt5n33po")
const WIN_UI = preload("uid://bb0cimgdasd16")
const PERSON = preload("uid://bf7js5xmur06k")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tutorial : Tutorial = TUTORIAL_UI.instantiate()
	add_child(tutorial)
	#await tutorial.tutorial_finished
	_spawn_person()
	$GameUi.game_over.connect(end_game)
	$GameUi._start_game()
	


func end_game():
	print("Game over")
	#get rid of people
	for child in $SpawnNode.get_children():
		child.queue_free()
	_spawn_gui("winui")

func _spawn_person():
	var inst = PERSON.instantiate()
	var customer = CustomerMap.get_random()
	
	inst.customer_res = customer
	$SpawnNode.call_deferred("add_child",inst)

	inst.z_index = -1
	inst.game_manager = self
	
	
func _spawn_gui(_type):
	match _type:
		"winui": #Spawn in win_ui
			$WinUi.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
