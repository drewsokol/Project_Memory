extends ComponentBase
class_name AnimationComponentBase

@export var animation_player : AnimationPlayer
@export var sprite_2d : Sprite2D

func _play_animation(_animation: String) -> void:
	push_error("_play_animation should be overriden when implementing AnimationPlayer")
