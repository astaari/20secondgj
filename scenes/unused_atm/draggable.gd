extends Node2D

var die = false
var deathSpeed = 0.25
var dragSpeed = 0.2
var teeny = Vector2(0.0,0.0)
var normalSize = Vector2(3.0,3.0)
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 1
	sprite_2d.scale = teeny


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Check if dropped
	if !Input.is_action_pressed("click"):
		die = true
	#if dropped, shrink until you're small enough to delete yourself
	if die:
		sprite_2d.scale = lerp(sprite_2d.scale,teeny,deathSpeed)
		if sprite_2d.scale.x < 0.01:
			queue_free()
	else: #Follow mouse
		sprite_2d.scale = lerp(sprite_2d.scale,normalSize,deathSpeed)
		global_position = lerp(global_position,get_global_mouse_position(),dragSpeed)
