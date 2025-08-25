# This base animation component requires overriding _play_animation()
# Which will recieve events as LocalEventData for parsing.
extends AnimationComponentBase

func _process_event(_event: LocalEventData):
	if(_event.name == "state_changed"):
		print("AP processing event: " + _event.to_string())
