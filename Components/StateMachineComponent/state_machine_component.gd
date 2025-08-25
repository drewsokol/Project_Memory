extends ComponentBase

@export var init_resource: StateMachineResource

var state_graph: StateGraph

func _ready() -> void:
	super._ready()
	state_graph = StateGraph.new()
	state_graph.load_from_resource(init_resource)

	state_graph.state_changed.connect(_on_state_changed)

func _process_event(_event: LocalEventData) -> void:
	state_graph.handle_event(_event.name)

func _on_state_changed(old_state: StateVertex, new_state: StateVertex) -> void:
	var data = {
		"old_state_id": old_state.id,
		"old_state_data": old_state.data,
		"new_state_id": new_state.id,
		"new_state_data": new_state.data
	}
	var local_event = LocalEventData.new(
		self,
		"state_changed",
		data
	)

	local_signal.emit(local_event)
