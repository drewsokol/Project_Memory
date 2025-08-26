# This base animation component requires overriding _play_animation()
# Which will recieve events as LocalEventData for parsing.
extends AnimationComponentBase

func _process_event(_event: LocalEventData) -> void:
	if(_event.name == "state_changed"):
		print("AP processing event: " + _event.to_string())
		var animation = _event.data.get("new_state_id", "idle") + "_"
		animation += _event.data.get("new_state_data", {}).get("direction", "down")
		_play_animation(animation)
		
func _play_animation(animation : String) -> void:
	animation_player.play(animation)
