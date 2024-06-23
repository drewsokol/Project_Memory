class_name HealthComponent extends Node2D

# Signals
signal health_changed(old_health, new_health)
signal health_depleted()
signal max_health_changed(new_max_health)

# Health Variables
var max_health: int = 100
var current_health: int = 100

# Set the maximum health value
func set_max_health(new_max_health: int):
	max_health = new_max_health
	if current_health > max_health:
		current_health = max_health
	emit_signal("max_health_changed", max_health)
	
# Get current maximum health value
func get_max_health() -> int:
	return max_health
	
# Get current health value
func get_current_health() -> int:
	return current_health
	
# Apply damage to health value
func take_damage(damage: int):
	var old_health = current_health
	current_health -= damage
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", old_health, current_health)
	if current_health == 0:
		emit_signal("health_depleted")
	
# Apply healing to health value
func heal(heal_amount: int):
	var old_health = current_health
	current_health += heal_amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", old_health, current_health)
