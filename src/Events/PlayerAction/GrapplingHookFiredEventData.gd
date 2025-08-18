class_name GrapplingHookFiredEventData extends EventData

var direction: Vector2
var target_position: Vector2

func _init(p_emitter: Node, p_target_position: Vector2):
	self.type = "GrapplingHookFiredEventData"
	self.emitter = p_emitter
	self.target_position = p_target_position

func _to_string():
	return "[GrapplingEvent: type=%s, emitter=%s, target_position=%s]" % [type, emitter.name, target_position]
