class_name HUD extends CanvasLayer

@onready var health_bar: HealthBar = $HealthBar
# Called when the node enters the scene tree for the first time.
func _ready():
	HudManager.player_set_max_health.connect(_on_max_health_changed)
	HudManager.player_health_changed.connect(_on_health_changed)

func _on_max_health_changed(new_max_health: float):
	health_bar.set_max_health(new_max_health)
	
func _on_health_changed(amount_changed: float):
	health_bar.health_changed(amount_changed)
