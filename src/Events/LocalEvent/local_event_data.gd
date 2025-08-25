class_name LocalEventData extends EventData

var name : String
var data : Dictionary

func _init(_emitter: Node, _name: String, _data: Dictionary = {}) -> void:
  self.type = "LocalEventData"
  self.name = _name
  self.data = _data
  self.emitter = _emitter

# A special method called by the `print()` function.
func _to_string():
  return "[LocalEventData, emitter=%s, name=%s, data=%s]" % [str(emitter.name) if emitter else "null", name, data]
