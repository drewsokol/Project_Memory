extends Node
class_name ComponentBase

@export var local_event_bus_path: NodePath
@onready var local_event_bus: LocalEventBus = get_node(local_event_bus_path)

signal local_signal

func _ready() -> void:
	local_event_bus.register_publisher(local_signal)
	local_event_bus.subscribe(_on_local_event)
	
func _on_local_event(_event: EventData) -> void:
	if _event.type == "LocalEventData":
		var _local_event = _event as LocalEventData
		_process_event(_local_event)

func _process_event(_event: LocalEventData) -> void:
	push_error("_process_event should be overriden in components when inheriting from component base")
