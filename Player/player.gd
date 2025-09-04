class_name Player extends CharacterBody2D

var PlayerEvents = preload("res://Player/player_events.gd")

signal player_action(event_data: EventData)
signal local_event(event_data: LocalEventData)

@onready var state_machine = $StateMachineComponent
@onready var local_bus = $LocalEventBus

# Called when the node enters the scene tree for the first time.
func _ready():
	_register_global_actions()
	call_deferred("_local_event_bus_setup")
	# connect input signals
	#$InputComponent.move_changed.connect(_on_move_changed)
	#$InputComponent.grappling_hook_fired.connect(_on_grappling_fired)
	
	## connect hud signals
	#$HealthComponent.max_health_changed.connect(_on_max_health_changed)
	#$HealthComponent.health_changed.connect(_on_health_changed)

func _physics_process(_delta):
	move_and_slide()
	
func _register_global_actions():
	Events.register_publisher(EventCategory.Category.PLAYER_ACTION, player_action)
	
func _local_event_bus_setup():
	local_bus.register_publisher(local_event)
	local_bus.subscribe(_handle_local_event)
	
func _handle_local_event(_event: LocalEventData) -> void:
	if(_event.emitter == self):
		return
	if(
		PlayerEvents.PlayerInput.is_run_event(_event.name) or
		PlayerEvents.PlayerInput.is_walk_event(_event.name)
		):
		_on_move_changed(_event.data.get("direction", Vector2.ZERO))
	
func _on_move_changed(new_direction: Vector2):
	var new_movement_event = LocalEventData.new(
		self,
		LocalEventTypes.MOVE_IN_DIRECTION,
		{"direction": new_direction}
		)
	local_event.emit(new_movement_event)
	velocity = $VelocityComponent.get_velocity()
	
func _on_grappling_fired(direction: Vector2):
	#temp distance for now
	var dist = 10
	var target = self.global_position +  (direction * dist)
	var data = GrapplingHookFiredEventData.new(self, target)
	player_action.emit(data)
	
#func _on_health_changed(old_health, new_health):
	#HudManager.player_health_changed.emit(float(new_health-old_health))
	#
#func _on_max_health_changed(new_max_health):
	#HudManager.player_set_max_health.emit(float(new_max_health))
