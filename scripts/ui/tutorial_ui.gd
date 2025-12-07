class_name Tutorial extends Panel

@onready var title: Label = $Title
@onready var desc: Label = $Desc

signal tutorial_finished

var base_size = Vector2(384.0,256.0) 
var game_manager

var page_current = 0

var page_text = ["Welcome to your first day on the job! Click the NEXT button to continue, or START if youre a returning employee.",
				"Grab customers with LMB or RMB, and throw them to the left or right. Let go when youre ready to send them one way or the other.",
				"Remember Send any red folk to the right, otherwise, the left works perfectly fine. Anything else wont do. And PLEASE, dont let a red to the left."]

func _ready():
	desc.text = page_text[page_current]
	
func _start_game():
	game_manager._start_game()
	tutorial_finished.emit()
	queue_free()

func _on_next_button_up() -> void:
	page_current = page_current + 1
	if page_current == page_text.size():
		_start_game()
	else:
		desc.text = page_text[page_current]

func _on_start_button_up() -> void:
	_start_game()
