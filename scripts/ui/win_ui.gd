extends Control

#Couldn't figure how to make this stick in the panel :P
var base_size = Vector2(384.0,256.0) 

func _on_return_to_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_retry_button_up() -> void:
	get_tree().reload_current_scene()
