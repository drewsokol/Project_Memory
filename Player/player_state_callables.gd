const PlayerEvents = preload("res://Player/player_events.gd")

static func on_idle_enter(_new_state: StateVertex, _data) -> void:
	var direction = _data.get("old_state_data", {}).get("direction", "down")
	_new_state.data["direction"] = direction

static func on_walk_run_enter(_new_state: StateVertex, _data) -> void:
	var direction = _data.get("event", PlayerEvents.PlayerInput.WALK_DOWN)

	match direction:
		PlayerEvents.PlayerInput.WALK_LEFT, PlayerEvents.PlayerInput.RUN_LEFT:
			_new_state.data["direction"] = "left"
		PlayerEvents.PlayerInput.WALK_RIGHT, PlayerEvents.PlayerInput.RUN_RIGHT:
			_new_state.data["direction"] = "right"
		PlayerEvents.PlayerInput.WALK_UP, PlayerEvents.PlayerInput.RUN_UP:
			_new_state.data["direction"] = "up"
		PlayerEvents.PlayerInput.WALK_DOWN, PlayerEvents.PlayerInput.RUN_DOWN:
			_new_state.data["direction"] = "down"
		_:
			_new_state.data["direction"] = "down"

static func idle_to_walk(event: String, _conditions: Dictionary = {}) -> bool:
	return PlayerEvents.PlayerInput.is_walk_event(event)

static func idle_to_run(event: String, _conditions: Dictionary = {}) -> bool:
	return PlayerEvents.PlayerInput.is_run_event(event)

static func move_to_idle(event: String, _conditions: Dictionary = {}) -> bool:
	return event == PlayerEvents.PlayerInput.MOVE_STOPPED
