class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 200.0
var state : String = "idle_down"

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SetDirection()
	state = GetState()
	print(direction)
	print(state)
	velocity = direction * move_speed
	UpdateAnimation()
	
func _physics_process(delta):
	move_and_slide()

func SetDirection() -> bool:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return true
	
func UpdateAnimation() -> void:
	animation_player.play(state)
	
func GetState() -> String:
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
	
