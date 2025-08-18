extends CharacterBody2D

func _ready():
	Events.subscribe(EventCategory.Category.PLAYER_ACTION, _on_player_action)

func _on_player_action(event_data: EventData):
	print("orc got the event. Event is: ", event_data.type)
	if event_data.type=="GrapplingHookFiredEventData":
		var data = event_data as GrapplingHookFiredEventData
		_on_grappling_hook_fired(data)
		
func _on_grappling_hook_fired(data: GrapplingHookFiredEventData):
	var player: Node2D
	if data.emitter is Node2D:
		player = data.emitter as Node2D
	else:
		push_error("grappling hook fired by incompatible node")
	print("grappling hook fired from %s to %s", player.global_position, data.target_position)
