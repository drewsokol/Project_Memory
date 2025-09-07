extends ComponentBase

var GrapplingEvents = preload("res://Player/player_events.gd").GrapplingEvents

var grapple_speed := 250.0
var grapple_distance := 50.0
var grapple_start_pos := Vector2.ZERO
var grapple_target_pos := Vector2.ZERO
var grapple_direction := Vector2.RIGHT

func _ready():
	super._ready()
	self.visible = false
	$AnimationPlayer.animation_finished.connect(_on_animation_complete)

func _process_event(_event: LocalEventData) -> void:
	if(
		_event.name == "state_changed" and
		_event.data.get("new_state_id", "") == "grapple_firing"
		):
		var direction = _event.data.get("new_state_data", "").get("direction", "down")
		_fire_grappling_hook(direction)
		
func _fire_grappling_hook(direction: String):
	print("Firing grappling hook to the " + direction)
	local_signal.emit(LocalEventData.new(self, GrapplingEvents.GRAPPLE_FIRED_START, {}))
	self.visible = true
	grapple_start_pos = self.global_position
	match direction:
		"left":
			grapple_direction = Vector2.LEFT
		"right":
			grapple_direction = Vector2.RIGHT
		"up":
			grapple_direction = Vector2.UP
		"down":
			grapple_direction = Vector2.DOWN
		_:
			grapple_direction = Vector2.RIGHT
	grapple_target_pos = grapple_start_pos + grapple_direction * grapple_distance
	_spawn_smoke_effect(direction)
	$AnimationPlayer.play("fire_" + direction)
	
	
func _on_animation_complete(_anim_name: String) -> void:
	if _anim_name == "fire_right":
		_on_fire_complete()

func _on_fire_complete() -> void:
	# Eventually will check for impacts, for now just retract
	local_signal.emit(LocalEventData.new(self, GrapplingEvents.GRAPPLE_FIRED_COMPLETED, {}))

	var travel_time = grapple_distance / grapple_speed
	var tween = create_tween()
	tween.tween_property(self, "global_position", grapple_target_pos, travel_time)
	tween.finished.connect(_on_grapple_reach_target)

func _on_grapple_reach_target() -> void:
	# For now, just retract
	_start_grapple_retract()

func _start_grapple_retract() -> void:
	# Eventually will manually animation retract, for now just wait a few seconds and then complete
	local_signal.emit(LocalEventData.new(self, GrapplingEvents.GRAPPLE_RETRACT_START, {"direction": grapple_direction}))
	
	var travel_time = grapple_distance / grapple_speed
	var tween = create_tween()
	tween.tween_property(self, "global_position", grapple_start_pos, travel_time)
	tween.finished.connect(_on_grapple_retract_complete)

func _on_grapple_retract_complete() -> void:
	# Emit completion and hide grappling hook
	self.visible = false
	local_signal.emit(LocalEventData.new(self, GrapplingEvents.GRAPPLE_RETRACT_COMPLETED, {"direction": grapple_direction}))

func _spawn_smoke_effect(direction: String):
	var smoke_effect_scene = preload("res://Player/effects/grapple_effects/grapple_fire_smoke_effect.tscn")
	var smoke_effect = smoke_effect_scene.instantiate()
	get_parent().add_child(smoke_effect)
	smoke_effect.global_position = self.global_position
	smoke_effect.play_effect(direction)
