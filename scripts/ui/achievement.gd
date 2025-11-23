extends Node2D

@export var title: String
@export var sprite : CompressedTexture2D

@onready var sprite_2d: Sprite2D = $Panel/Sprite2D
@onready var label: Label = $Panel/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = sprite
	label.text = title
