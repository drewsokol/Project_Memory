class_name StateGraph extends GraphStructure

signal state_changed(old_state: StateVertex, new_state: StateVertex)

var current_state: StateVertex = null

func _init():
	super._init(true)

# Internal: Add a state
func _add_state(id: String, on_enter: Callable, data: Dictionary = {}, update_self: bool = false) -> StateVertex:
	var state = StateVertex.new(id, on_enter, update_self)
	state.data = data
	vertices.append(state)
	if current_state == null:
		current_state = state
	return state

# Internal: Add a transition
func _add_transition(
	from: StateVertex,
	to: StateVertex,
	event_requirement: Callable = func(_event: String, _conditions: Dictionary) -> bool: return true,
	data: Dictionary = {}) -> StateTransition:
	var transition = StateTransition.new(from, to, event_requirement)
	transition.data = data
	edges.append(transition)
	from.neighbors.append(to)
	return transition

# Get a state by ID
func get_state(id: String) -> StateVertex:
	for state in vertices:
		if state.id.to_lower() == id.to_lower():
			return state
	return null

# Attempt to transition to a new state
func transition_to(target_state_id: String, event_name: String) -> bool:
	var target_state = get_state(target_state_id)
	if current_state == null or target_state == null:
		return false
	for edge in get_edges(current_state):
		if edge.to == target_state and edge.can_transition(event_name):
			var old_state = current_state
			current_state = target_state
			var data = {
				"event": event_name,
				"old_state_data": old_state.data
			}
			target_state._on_enter.call(target_state, data)
			_clear_conditions_for_state(current_state)
			state_changed.emit(old_state, current_state)
			return true
	return false

# Handle an event and attempt transitions
func handle_event(event: String) -> bool:
	if current_state == null:
		return false
	for edge in get_edges(current_state):
		if edge.can_transition(event):
			return transition_to(edge.to.id, event)
	if current_state.update_self:
		current_state._on_enter.call(current_state, {"event": event, "old_state_data": current_state.data})
		state_changed.emit(current_state, current_state)
	return false

# Load state machine from a resource
func load_from_resource(resource: StateMachineResource) -> void:
	vertices.clear()
	edges.clear()
	current_state = null
	_load_states(resource.states)
	_load_transitions(resource.transitions)

func _load_states(states: Array[Dictionary]) -> void:
	vertices.clear()
	for state_data in states:
		var on_enter_callable = _reconstruct_callable(
			state_data.get("on_enter", {})
		)
		var additional_data = state_data.get("data", {})
		var self_update = state_data.get("self_update", false)
		_add_state(state_data.id, on_enter_callable, additional_data, self_update)

func _load_transitions(transitions: Array[Dictionary]) -> void:
	edges.clear()
	for transition_data in transitions:
		var from_state = get_state(transition_data.from_id)
		var to_state = get_state(transition_data.to_id)
		if from_state and to_state:
			var event_requirement = _reconstruct_callable(
				transition_data.get("event_requirement", {}),
			)
			var transition = _add_transition(from_state, to_state, event_requirement)
			if transition_data.has("conditions_met"):
				transition.conditions_met = transition_data.conditions_met
			if transition_data.has("data"):
				transition.data = transition_data.data

func serialize() -> Dictionary:
	var state_data = []
	for state in vertices:
		state_data.append({"id": state.id, "data": state.data})

	var transition_data = []
	for transition in edges:
		var event = transition.data.get("event", "")
		var event_requirement = {}
		if transition.event_requirement.is_valid():
			var callable = transition.event_requirement
			if callable.get_object() and callable.get_method():
				var obj = callable.get_object()
				if obj and obj.get_script():
					var script = obj.get_script()
					if script and script.resource_path != "":
						event_requirement = {
							"script_path": script.resource_path,
							"method_name": callable.get_method()
						}
		transition_data.append({
			"from_id": transition.from.id,
			"to_id": transition.to.id,
			"event": event,
			"event_requirement": event_requirement,
			"data": transition.data,
			"conditions_met": transition.conditions_met
		})

	return {
		"states": state_data,
		"transitions": transition_data,
		"current_state_id": current_state.id if current_state else ""
	}

func deserialize(data: Dictionary) -> void:
	vertices.clear()
	edges.clear()
	current_state = null

	for state_data in data.get("states", []):
		_add_state(state_data.id, state_data.get("data", {}))

	for transition_data in data.get("transitions", []):
		var from_state = get_state(transition_data.from_id)
		var to_state = get_state(transition_data.to_id)
		if from_state and to_state:
			var event_requirement = _reconstruct_callable(
				transition_data.get("event_requirement", {})
			)
			var transition = _add_transition(from_state, to_state, event_requirement, transition_data.get("data", {}))
			transition.conditions_met = transition_data.get("conditions_met", {})

	var current_state_id = data.get("current_state_id", "")
	if current_state_id != "":
		current_state = get_state(current_state_id)

func _reconstruct_callable(callable_dict: Dictionary) -> Callable:
	var callable = Callable()
	if callable_dict.has("script_path") and callable_dict.has("method_name") and callable_dict.script_path != "" and callable_dict.method_name != "":
		var script = load(callable_dict.script_path)
		if script:
			if script.has_method(callable_dict.method_name):
				callable = Callable(script, callable_dict.method_name)
			else:
				push_warning("Method %s not found in script %s" % [callable_dict.method_name, callable_dict.script_path])
		else:
			push_warning("Script not found: %s" % callable_dict.script_path)
	return callable

func _clear_conditions_for_state(state: StateVertex) -> void:
	for edge in get_edges(state):
			edge.conditions_met.clear()
