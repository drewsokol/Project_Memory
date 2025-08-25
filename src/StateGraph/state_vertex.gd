class_name StateVertex
extends GraphVertex

var _on_enter : Callable

func _init(_id: String, _on_enter_func: Callable = _default_on_enter):
	super._init(_id)
	self._on_enter = _on_enter_func

static func _default_on_enter(_new_state: StateVertex, _data = {}) -> void:
	pass
