class_name VelocityComponent extends ComponentBase

var current_velocity: Vector2 = Vector2.ZERO
var move_speed: float = 150

# Return the current velocity
func get_velocity() -> Vector2:
	return current_velocity
	
# Return direction in radians
func get_direction() -> float:
	return current_velocity.angle()

# Return direction in degrees
func get_direction_degrees() -> float:
	return rad_to_deg(current_velocity.angle())

func set_velocity(new_velocity: Vector2):
	current_velocity = new_velocity

func move_in_direction(direction: Vector2):
	current_velocity = direction.normalized() * move_speed

func apply_force(force: Vector2):
	current_velocity += force

func _process_event(_event: LocalEventData) -> void:
	if(_event.name == LocalEventTypes.SET_VELOCITY):
		var new_velocity = _event.data.get("velocity", Vector2.ZERO)
		set_velocity(new_velocity)
	elif(_event.name == LocalEventTypes.MOVE_IN_DIRECTION):
		var direction = _event.data.get("direction", Vector2.ZERO)
		move_in_direction(direction)
	elif(_event.name == LocalEventTypes.APPLY_FORCE):
		var force = _event.data.get("force", Vector2.ZERO)
		apply_force(force)
