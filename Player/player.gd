class_name Player extends CharacterBody2D

var state : String = "idle_down"

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

signal player_action(event_data: EventData)

# Called when the node enters the scene tree for the first time.
func _ready():
	_register_global_actions()
	# connect input signals
	$InputComponent.move_changed.connect(_on_move_changed)
	$InputComponent.grappling_hook_fired.connect(_on_grappling_fired)
	
	## connect hud signals
	#$HealthComponent.max_health_changed.connect(_on_max_health_changed)
	#$HealthComponent.health_changed.connect(_on_health_changed)
	
	#start animations
	UpdateAnimation()

func _physics_process(delta):
	move_and_slide()
	
func _register_global_actions():
	Events.register_publisher(EventCategory.Category.PLAYER_ACTION, player_action)

func SetDirection() -> bool:
	return true
	
func UpdateAnimation() -> void:
	animation_player.play(state)
	
func GetState() -> String:
	var direction = $VelocityComponent.getVelocity()
	if direction.x < 0:
		return "walk_left"
	elif direction.x > 0:
		return "walk_right"
	elif direction.y < 0:
		return "walk_up"
	elif direction.y > 0:
		return "walk_down"
	if direction.x == 0 and direction.y == 0:
		if state.split("_")[0] == "idle":
			return state
		if state == "walk_left":
			return "idle_left"
		elif state == "walk_right":
			return "idle_right"
		elif state == "walk_up":
			return "idle_up"
	return "idle_down"
	
func _on_move_changed(new_direction: Vector2):
	$VelocityComponent.setDirection(new_direction)
	state = GetState()
	velocity = $VelocityComponent.getVelocity()
	UpdateAnimation()
	
func _on_grappling_fired(direction: Vector2):
	#temp distance for now
	var dist = 10
	var target = self.global_position +  (direction * dist)
	var data = GrapplingHookFiredEventData.new(self, target)
	
	var state = GetState()
	if state == "walk_right" or state == "idle_right":
		state = "grappling_fire_right"
		print("state is now: ", state)
	
	UpdateAnimation()
	player_action.emit(data)
	
#func _on_health_changed(old_health, new_health):
	#HudManager.player_health_changed.emit(float(new_health-old_health))
	#
#func _on_max_health_changed(new_max_health):
	#HudManager.player_set_max_health.emit(float(new_max_health))
