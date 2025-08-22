class_name StateMachineResource extends Resource

# [{id: String, data: Dictionary}]
@export var states: Array[Dictionary] = []

# [{from_id: String, to_id: String, event: String, event_requirement: Dictionary, data: Dictionary, conditions_met: Dictionary}]
@export var transitions: Array[Dictionary] = []
