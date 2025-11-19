extends MarginContainer

#signal timeout

var GAME_TIME : float = 20.0

@onready
var timer_ui : Label = %GameTimer

### TODO Could be improved. Likely needs to be redone or states moved around.
func _ready() -> void:
	timer_ui.get_tree().create_timer(GAME_TIME).timeout.connect(_placehold_gameover)
	
	
	
	
	pass

func _placehold_gameover():
	print("Game over")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GAME_TIME-=delta
	timer_ui.text = "%.2f" % GAME_TIME
	
	
