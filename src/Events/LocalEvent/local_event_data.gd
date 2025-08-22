class_name LocalEventData extends EventData

func _init(_emitter: Node, _name: String, _data: Dictionary = {}) -> void:
  self.type = "LocalEventData"
  self.name = _name
  self.data = _data
  self.emitter = _emitter
