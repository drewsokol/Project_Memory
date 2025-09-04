extends ComponentBase
class_name AnimationComponentBase

@export var animation_player : AnimationPlayer
@export var sprite_2d : Sprite2D

func _ready() -> void:
	super._ready()
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)

func _play_animation(_animation: String) -> void:
	push_error("_play_animation should be overriden when implementing AnimationPlayer")

func _on_animation_finished(_anim_name: String) -> void:
	local_signal.emit(LocalEventData.new(self, _anim_name + "_animation_finished", {}))