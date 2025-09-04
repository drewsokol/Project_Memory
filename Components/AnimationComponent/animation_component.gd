# This base animation component requires overriding _play_animation()
# Which will recieve events as LocalEventData for parsing.
extends AnimationComponentBase

const animation_map :  Dictionary = {
	"idle_left" : "idle_left",
	"idle_right" : "idle_right",
	"idle_up" : "idle_up",
	"idle_down" : "idle_down",
	"walk_left" : "walk_left",
	"walk_right" : "walk_right",
	"walk_up" : "walk_up",
	"walk_down" : "walk_down",
	"grapple_firing_right" : "grapple_firing_right",
}

func _process_event(_event: LocalEventData) -> void:
	if(_event.name == "state_changed"):
		print("AP processing event: " + _event.to_string())
		var animation = _event.data.get("new_state_id", "idle") + "_"
		animation += _event.data.get("new_state_data", {}).get("direction", "down")
		_play_animation(animation)
		
func _play_animation(event : String) -> void:
	var animation = animation_map.get(event, "")
	if animation_player and animation_player.has_animation(animation):
		animation_player.play(animation)
	else:
		push_warning("Animation not found: %s" % animation)
	