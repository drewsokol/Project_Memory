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

static func on_grapple_firing_enter(_new_state: StateVertex, _data) -> void:
	var direction = _data.get("old_state_data", {}).get("direction", "right")
	_new_state.data["direction"] = direction

static func on_grapple_retracting_enter(_new_state: StateVertex, _data) -> void:
	var direction = _data.get("old_state_data", {}).get("direction", "right")
	_new_state.data["direction"] = direction

static func idle_to_walk(event: String, _conditions: Dictionary = {}) -> bool:
	return PlayerEvents.PlayerInput.is_walk_event(event)

static func idle_to_run(event: String, _conditions: Dictionary = {}) -> bool:
	return PlayerEvents.PlayerInput.is_run_event(event)

static func move_to_idle(event: String, _conditions: Dictionary = {}) -> bool:
	return event == PlayerEvents.PlayerInput.MOVE_STOPPED

static func can_fire_grapple(event: String, _conditions: Dictionary = {}) -> bool:
	return event == PlayerEvents.PlayerInput.GRAPPLE_FIRE

static func grapple_firing_to_grapple_retracting(event: String, _conditions: Dictionary = {}) -> bool:
	if event.contains(PlayerEvents.GrapplingEvents.GRAPPLE_RETRACT_START):
		return true
	return false
		
static func grapple_retracting_to_idle(event: String, _conditions: Dictionary = {}) -> bool:
	if event.contains(PlayerEvents.GrapplingEvents.GRAPPLE_RETRACT_COMPLETED):
		_conditions[PlayerEvents.GrapplingEvents.GRAPPLE_RETRACT_COMPLETED] = true
	if event.contains("grapple_retracting_") and event.contains("animation_finished"):
		_conditions["grapple_retract_animation_completed"] = true

	var animation_complete = _conditions.get("grapple_retract_animation_completed", false)
	var retract_complete = _conditions.get(PlayerEvents.GrapplingEvents.GRAPPLE_RETRACT_COMPLETED, false)
	var all_conditions_met = retract_complete and animation_complete

	return all_conditions_met
