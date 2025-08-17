class_name EventData extends RefCounted

# The type of the event. This must be a string representing the class name.
# Inheriting classes are required to set this property in their _init() function.
# Example: self.type = self.get_class()
var type: String

# The node that emitted the event.
var emitter: Node
