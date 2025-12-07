extends Panel

var base_size = Vector2(384.0,256.0) 
var game_manager


func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = !visible

func _on_resume_button_up() -> void:
	toggle_pause()

func _on_return_to_menu_button_up() -> void:
	toggle_pause()
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

	
	
