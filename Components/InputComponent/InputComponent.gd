class_name InputComponent extends ComponentBase

const PlayerEvents = preload("res://Player/player_events.gd")

signal move_changed(direction)
signal grappling_hook_fired(direction)

var current_move_direction = Vector2.ZERO
var is_running = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_movement_changed():
		on_move_changed()
	if is_grappling_hook_fired():
		on_grappling_hook_fired()
		
func _process_event(_event: LocalEventData):
	pass

# Check if movement keys have changed
func is_movement_changed() -> bool:
	var new_direction = Vector2.ZERO;
	new_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	new_direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	var run_pressed = Input.is_action_pressed("run")
	var run_changed = run_pressed != is_running
	is_running = run_pressed

	if new_direction == current_move_direction:
		if new_direction != Vector2.ZERO and run_changed:
			return true
		return false
	
	current_move_direction = new_direction
	return true
	
func is_grappling_hook_fired() -> bool:
	if Input.is_action_just_pressed("fire_grappling_hook"):
		return true
	return false
	
func on_grappling_hook_fired():
	grappling_hook_fired.emit(current_move_direction)
	var grappling_hook_data = LocalEventData.new(
		self,
		PlayerEvents.PlayerInput.GRAPPLE_FIRE,
		{"direction": current_move_direction}
	)
	local_signal.emit(grappling_hook_data)
	
# Broadcast new movemnt signals
func on_move_changed():
	move_changed.emit(current_move_direction)
	var movement_data = LocalEventData.new(
		self,
		PlayerEvents.PlayerInput.get_move_event_from_vector(current_move_direction, is_running),
		{"direction": current_move_direction}
		)
	local_signal.emit(movement_data)
	
func cancel_movement():
	current_move_direction = Vector2.ZERO
