class PlayerInput:

	const WALK_LEFT = "input.movement_changed.walk_left"
	const WALK_RIGHT = "input.movement_changed.walk_right"
	const WALK_UP = "input.movement_changed.walk_up"
	const WALK_DOWN = "input.movement_changed.walk_down"

	const RUN_LEFT = "input.movement_changed.run_left"
	const RUN_RIGHT = "input.movement_changed.run_right"
	const RUN_UP = "input.movement_changed.run_up"
	const RUN_DOWN = "input.movement_changed.run_down"

	const MOVE_STOPPED = "input.movement_changed.stopped"

	const GRAPPLE_FIRE = "input.fire.grapple_fire"

	static func is_walk_event(event: String) -> bool:
		return event in [
			WALK_LEFT,
			WALK_RIGHT,
			WALK_UP,
			WALK_DOWN,
			MOVE_STOPPED
		]

	static func is_run_event(event: String) -> bool:
		return event in [
			RUN_LEFT,
			RUN_RIGHT,
			RUN_UP,
			RUN_DOWN
		]

	static func get_move_event_from_direction(direction: String, is_running: bool = false) -> String:
		match direction:
			"left":
				return RUN_LEFT if is_running else WALK_LEFT
			"right":
				return RUN_RIGHT if is_running else WALK_RIGHT
			"up":
				return RUN_UP if is_running else WALK_UP
			"down":
				return RUN_DOWN if is_running else WALK_DOWN
			"":
				return MOVE_STOPPED
		return ""

	static func get_move_event_from_vector(direction: Vector2, is_running: bool = false) -> String:
		if direction == Vector2.ZERO:
			return MOVE_STOPPED
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				return RUN_RIGHT if is_running else WALK_RIGHT
			else:
				return RUN_LEFT if is_running else WALK_LEFT
		else:
			if direction.y > 0:
				return RUN_DOWN if is_running else WALK_DOWN
			else:
				return RUN_UP if is_running else WALK_UP

class StateEvents:
	
	const TO_IDLE = "state.enter.idle"

class GrapplingEvents:

	const GRAPPLE_FIRED_START = "grapple.fired.start"
	const GRAPPLE_FIRED_COMPLETED = "grapple.fired.completed"
	const GRAPPLE_RETRACT_START = "grapple.retract.start"
	const GRAPPLE_RETRACT_COMPLETED = "grapple.retract.completed"