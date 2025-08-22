class_name StateGraph extends GraphStructure

signal state_changed(old_state: StateVertex, new_state: StateVertex)

var current_state: StateVertex = null

func _init():
	super._init(true)

# Internal: Add a state
func _add_state(id: String, data: Dictionary = {}) -> StateVertex:
	var state = StateVertex.new(id)
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
func transition_to(target_state_id: String) -> bool:
	var target_state = get_state(target_state_id)
	if current_state == null or target_state == null:
		return false
	for edge in get_edges(current_state):
		if edge.to == target_state and edge.can_transition(""):
			var old_state = current_state
			current_state = target_state
			state_changed.emit(old_state, current_state)
			_clear_conditions_for_state(current_state)
			return true
	return false

# Handle an event and attempt transitions
func handle_event(event: String) -> bool:
	if current_state == null:
		return false
	for edge in get_edges(current_state):
		if edge.can_transition(event):
			var old_state = current_state
			current_state = edge.to
			state_changed.emit(old_state, current_state)
			_clear_conditions_for_state(current_state)
			return true
	return false

# Load state machine from a resource
func load_from_resource(resource: StateMachineResource) -> void:
	vertices.clear()
	edges.clear()
	current_state = null

	for state_data in resource.states:
		_add_state(state_data.id, state_data.data)

	for transition_data in resource.transitions:
		var from_state = get_state(transition_data.from_id)
		var to_state = get_state(transition_data.to_id)
		if from_state and to_state:
			var event_requirement = _reconstruct_event_requirement(
				transition_data.get("event_requirement", {}),
				transition_data.get("event", "")
			)
			var transition = _add_transition(from_state, to_state, event_requirement, transition_data.data)
			if transition_data.has("conditions_met"):
				transition.conditions_met = transition_data.conditions_met
				
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
			var event_requirement = _reconstruct_event_requirement(
				transition_data.get("event_requirement", {}),
				transition_data.get("event", "")
			)
			var transition = _add_transition(from_state, to_state, event_requirement, transition_data.get("data", {}))
			transition.conditions_met = transition_data.get("conditions_met", {})

	var current_state_id = data.get("current_state_id", "")
	if current_state_id != "":
		current_state = get_state(current_state_id)

func _reconstruct_event_requirement(er_dict: Dictionary, event: String = "") -> Callable:
	var event_requirement = Callable()
	if er_dict.has("script_path") and er_dict.has("method_name") and er_dict.script_path != "" and er_dict.method_name != "":
		var script = load(er_dict.script_path)
		if script:
			var instance = script.new()
			if instance.has_method(er_dict.method_name):
				event_requirement = Callable(instance, er_dict.method_name)
			else:
				push_warning("Method %s not found in script %s" % [er_dict.method_name, er_dict.script_path])
		else:
			push_warning("Script not found: %s" % er_dict.script_path)
	elif event != "":
		var event_name = event
		event_requirement = func(incoming_event: String, conditions: Dictionary) -> bool:
			if event == event_name:
				conditions[incoming_event] = true
			return conditions.get(event_name, false)
	return event_requirement

func _clear_conditions_for_state(state: StateVertex) -> void:
	for edge in get_edges(state):
			edge.conditions_met.clear()
