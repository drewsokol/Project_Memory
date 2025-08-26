class_name Player extends CharacterBody2D

signal player_action(event_data: EventData)

@onready var state_machine = $StateMachineComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	_register_global_actions()
	# connect input signals
	$InputComponent.move_changed.connect(_on_move_changed)
	$InputComponent.grappling_hook_fired.connect(_on_grappling_fired)
	
	## connect hud signals
	#$HealthComponent.max_health_changed.connect(_on_max_health_changed)
	#$HealthComponent.health_changed.connect(_on_health_changed)

func _physics_process(delta):
	move_and_slide()
	
func _register_global_actions():
	Events.register_publisher(EventCategory.Category.PLAYER_ACTION, player_action)
	
func _on_move_changed(new_direction: Vector2):
	$VelocityComponent.setDirection(new_direction)
	velocity = $VelocityComponent.getVelocity()
	
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
