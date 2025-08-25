class_name StateTransition extends GraphEdge

var event_requirement: Callable  # Function taking an event String, returning bool
var conditions_met: Dictionary = {}  # Tracks events or conditions

func _init(
	_from: StateVertex,
	_to: StateVertex,
	_event_requirement: Callable = _default_event_requirement
	):
	super._init(_from, _to)
	event_requirement = _event_requirement

func can_transition(event: String) -> bool:
	return event_requirement.call(event, conditions_met)

static func _default_event_requirement(_event: String, _conditions: Dictionary = {}) -> bool:
	return true
