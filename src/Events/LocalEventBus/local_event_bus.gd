extends Node
class_name LocalEventBus

var event_system: EventSystem

func _ready() -> void:
  event_system = EventSystem.new()
  add_child(event_system)

func subscribe(callback: Callable) -> void:
  event_system.subscribe(EventCategory.Category.LOCAL, callback)

func unsubscribe(callback: Callable) -> void:
  event_system.unsubscribe(EventCategory.Category.LOCAL, callback)

func register_publisher(publisher_signal: Signal) -> void:
  event_system.register_publisher(EventCategory.Category.LOCAL, publisher_signal)
