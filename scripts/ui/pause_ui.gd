extends Panel

var base_size = Vector2(384.0,256.0) 
var game_manager

func _on_resume_button_up() -> void:
	game_manager.state = game_manager.PLAY
	queue_free()

func _on_return_to_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")
