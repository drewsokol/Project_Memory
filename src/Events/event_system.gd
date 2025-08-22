class_name EventSystem extends Node

var _signals: Dictionary = {
	EventCategory.Category.LOCAL: Signal(self, "local_event_signal"),
	EventCategory.Category.ENVIRONMENT_ACTION: Signal(self, "environment_action_signal"),
	EventCategory.Category.PLAYER_ACTION: Signal(self, "player_action_signal"),
}

signal local_event_signal(event: EventData)
signal player_action_signal(event: EventData)
signal environment_action_signal(event: EventData)

func subscribe(event_category: EventCategory.Category, callback: Callable) -> void:
	if _signals.has(event_category):
		_signals[event_category].connect(callback)
	else:
		push_warning("No signal defined for category: %s" % event_category)

func unsubscribe(event_category: EventCategory.Category, callback: Callable) -> void:
	if _signals.has(event_category):
		_signals[event_category].disconnect(callback)

func register_publisher(event_category: EventCategory.Category, publisher_signal: Signal) -> void:
	if _signals.has(event_category):
		var relay = func(event_data: EventData): _signals[event_category].emit(event_data)
		publisher_signal.connect(relay)
	else:
		push_warning("No signal defined for category: %s" % event_category)
