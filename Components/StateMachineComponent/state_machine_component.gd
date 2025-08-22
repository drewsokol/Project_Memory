extends Node

@export var init_resource: StateMachineResource
@export var local_event_bus: EventSystem

# Signals
var state_changed: Signal

var state_graph: StateGraph

func _ready() -> void:
	state_graph = StateGraph.new()
	state_graph.load_from_resource(init_resource)
	local_event_bus.subscribe(EventCategory.Category.LOCAL, _on_local_event)

func _on_local_event(event: EventData) -> void:
	if event.type == "LocalEventData":
		var local_event = event as LocalEventData
		state_graph.handle_event(local_event.name)
