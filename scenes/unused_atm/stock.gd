extends Button

@export var title = "Cigarettes"

const DRAGGABLE = preload("uid://bnldlo5hxadjr")

func _ready():
	text = "     " + title + "     "

func _on_button_down() -> void:
	var inst = DRAGGABLE.instantiate()
	add_child(inst)
	inst.global_position = get_global_mouse_position()
