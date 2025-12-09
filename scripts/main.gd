extends Node2D


signal score_changed(score)


const TUTORIAL_UI = preload("uid://twfgvt5n33po")
const PERSON = preload("uid://bf7js5xmur06k")

var disallowed_tags = []

	




var score : int = 0 : 
	set(value):
		score = value
		score_changed.emit(value)
	get():
		return score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while len(disallowed_tags)< 2:
		var r = randi_range(0,len(CustomerData.available_tags)-1)
		if CustomerData.available_tags[r] in disallowed_tags:
			continue
		disallowed_tags.append(CustomerData.available_tags[r])
	$GameUi.set_banned_items(disallowed_tags)
	var tutorial : Tutorial = TUTORIAL_UI.instantiate()
	
	add_child(tutorial)
	#await tutorial.tutorial_finished
	_spawn_person()
	$GameUi.game_over.connect(end_game)
	$GameUi._start_game()
	
	#this is probably bad
	score_changed.connect($GameUi.set_score)
	


func end_game():
	print("Game over")
	#get rid of people
	for child in $SpawnNode.get_children():
		child.queue_free()
	_spawn_gui("winui")

func _handle_person_sent(direction,customer : Customer):
	var customer_valid : bool = true

	for tag in disallowed_tags:
		if tag in customer.tags:
			customer_valid = false
			print("invalid!",customer.name)
			break
	if direction == "left" and customer_valid:
		score+=1
	elif direction == "right" and not customer_valid:
		score+=1
			

func _spawn_person():
	var inst = PERSON.instantiate()
	var customer = CustomerData.get_random()
	inst.person_sent.connect(_handle_person_sent)
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
