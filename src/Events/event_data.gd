class_name EventData extends RefCounted

# The type of the event. This must be a string representing the class name.
# Inheriting classes are required to set this property in their _init() function.
# Example: self.type = self.get_class()
var type: String

# The node that emitted the event.
var emitter: Node

# A special method called by the `print()` function.
func _to_string():
	return "[EventData: type=%s, emitter=%s]" % [type, emitter.name if emitter else "null"]
	
