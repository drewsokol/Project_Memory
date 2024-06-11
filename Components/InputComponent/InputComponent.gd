class_name InputComponent extends Node2D

signal move_changed(direction)
var current_move_direction = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_movement_changed():
		on_move_changed()

# Check if movement keys have changed
func is_movement_changed() -> bool:
	var new_direction = Vector2.ZERO;
	new_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	new_direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if new_direction == current_move_direction:
		return false
	
	current_move_direction = new_direction
	return true
	
# Broadcast new movemnt signals
func on_move_changed():
	move_changed.emit(current_move_direction)
	
func cancel_movement():
	current_move_direction = Vector2.ZERO
