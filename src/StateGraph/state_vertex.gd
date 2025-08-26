class_name StateVertex
extends GraphVertex

var _on_enter : Callable
var update_self: bool = false

func _init(_id: String, _on_enter_func: Callable = _default_on_enter, _update_self = false):
	super._init(_id)
	self._on_enter = _on_enter_func
	self.update_self = _update_self

static func _default_on_enter(_new_state: StateVertex, _data = {}) -> void:
	pass
