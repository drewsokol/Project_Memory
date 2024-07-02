class_name HealthBar extends Control

var max_health: float = 100
@onready var progress_bar: TextureProgressBar = $TextureProgressBar

func _ready():
	progress_bar.value = max_health

func set_current_health(new_value: float):
	progress_bar.value = clamp(new_value/max_health * 100, 0, 100)
	
func set_max_health(new_value: float):
	var current_health = max_health * progress_bar.value
	max_health = new_value
	progress_bar.value = clamp(current_health/new_value, 1, 100)
	
# Change displayed health by the change_amount
func health_changed(change_amount: float):
	var percent_changed = change_amount/max_health * 100
	progress_bar.value += percent_changed
