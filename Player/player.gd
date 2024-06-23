class_name Player extends CharacterBody2D

var state : String = "idle_down"

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect input signals
	$InputComponent.move_changed.connect(_on_move_changed)
	
	# connect hud signals
	$HealthComponent.max_health_changed.connect(_on_max_health_changed)
	$HealthComponent.health_changed.connect(_on_health_changed)

func _physics_process(delta):
	move_and_slide()

func SetDirection() -> bool:
	return true
	
func UpdateAnimation() -> void:
	animation_player.play(state)
	
func GetState() -> String:
	var direction = $VelocityComponent.getVelocity()
	if direction.x < 0:
		return "run_left"
	elif direction.x > 0:
		return "run_right"
	elif direction.y < 0:
		return "run_up"
	elif direction.y > 0:
		return "run_down"
	if direction.x == 0 and direction.y == 0:
		if state.split("_")[0] == "idle":
			return state
		if state == "run_left":
			return "idle_left"
		elif state == "run_right":
			return "idle_right"
		elif state == "run_up":
			return "idle_up"
	return "idle_down"
	
func _on_move_changed(new_direction: Vector2):
	$VelocityComponent.setDirection(new_direction)
	state = GetState()
	velocity = $VelocityComponent.getVelocity()
	UpdateAnimation()
	
func _on_health_changed(old_health, new_health):
	HudManager.player_health_changed.emit(float(new_health-old_health))
	
func _on_max_health_changed(new_max_health):
	HudManager.player_set_max_health.emit(float(new_max_health))
