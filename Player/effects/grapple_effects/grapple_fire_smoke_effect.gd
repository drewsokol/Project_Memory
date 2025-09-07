extends Node2D

@onready var animation_player = $AnimationPlayer

func play_effect(direction: String):
	var animation = "fire_" + direction
	animation_player.play(animation)
	animation_player.animation_finished.connect(_on_smoke_finished)
	
func _on_smoke_finished(_anim_name: String) -> void:
	queue_free()
