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
func _add_transition(from: StateVertex, to: StateVertex, event_requirement: Callable = func(_event: String) -> bool: return true, data: Dictionary = {}) -> StateTransition:
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
			var event_requirement = transition_data.event_requirement
			if not event_requirement.is_valid() and transition_data.event != "":
				event_requirement = func(event: String, conditions: Dictionary) -> bool:
					if event == transition_data.event:
						conditions[event] = true
					return conditions.get(transition_data.event, false)
			elif transition_data.event_requirement_dict.get("script_path", "") != "" and transition_data.event_requirement_dict.get("method_name", "") != "":
				var script = load(transition_data.event_requirement_dict.script_path)
				if script:
					event_requirement = script.new().call(transition_data.event_requirement_dict.method_name)
			var transition = _add_transition(from_state, to_state, event_requirement, transition_data.data)
			if transition_data.conditions_met:
				transition.conditions_met = transition_data.conditions_met
func serialize() -> Dictionary:
	var state_data = []
	for state in vertices:
		state_data.append({"id": state.id, "data": state.data})
	
	var transition_data = []
	for transition in edges:
		var event = ""
		var event_requirement = Callable()
		if transition.event_requirement.is_valid():
			# For serialization, store as script path or event string
			event = transition.data.get("event", "")
		transition_data.append({
			"from_id": transition.from.id,
			"to_id": transition.to.id,
			"event": event,
			"event_requirement": event_requirement,  # Placeholder, not serialized
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
			var event_requirement = transition_data.get("event_requirement", Callable())
			if not event_requirement.is_valid() and transition_data.get("event", "") != "":
				event_requirement = func(event: String, conditions: Dictionary) -> bool:
					if event == transition_data.event:
						conditions[event] = true
					return conditions.get(transition_data.event, false)
			var transition = _add_transition(from_state, to_state, event_requirement, transition_data.get("data", {}))
			transition.conditions_met = transition_data.get("conditions_met", {})
	
	var current_state_id = data.get("current_state_id", "")
	if current_state_id != "":
		current_state = get_state(current_state_id)
