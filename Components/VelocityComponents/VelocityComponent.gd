class_name VelocityComponent extends Node2D

var current_velocity: Vector2 = Vector2.ZERO
var move_speed: float = 200

# Set current direction for velocity
func setDirection(new_direction: Vector2):
	current_velocity = new_direction.normalized() * move_speed

# Return the current velocity
func getVelocity() -> Vector2:
	return current_velocity
	
# Return direction in radians
func getDirection() -> float:
	return current_velocity.angle()

# Return direction in degrees
func getDirectionDegrees() -> float:
	return rad_to_deg(current_velocity.angle())
