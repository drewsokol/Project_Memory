# AnimationComponent

>A modular base component for handling animation logic in Godot, designed for use with an event-driven, component-based architecture.

---

## 🚀 Quick Start

1. **Add to Your Scene:**
   - Drag `AnimationComponent.tscn` into your entity (e.g., Player) scene as a child node.
   - Right-click and select **"Make Local"** if you want to customize it for this entity.

2. **Assign Dependencies:**
   - In the Inspector, assign the `animation_player` (your `AnimationPlayer` node) and `sprite_2d` (your `Sprite2D` node, if needed).
   - Assign the `local_event_bus` property (inherited from `ComponentBase`) to your entity's `LocalEventBus` node.

3. **Implement Animation Logic:**
   - Modify the attached script
   - Override the `_play_animation(_animation: String)` method to define how animations are played based on events.
   - Override `_process_event(_event: LocalEventData)` to handle event logic

---

## 🧩 How It Works

- **Event-Driven:**
  - The component subscribes to the local event bus and receives events as `LocalEventData`.
  - When an event is received, `_process_event(_event)` is called.
  - You should override these methods to implement your animation logic.

- **Extensible:**
  - Use as a base for all animation components. Add custom logic per entity as needed.
  - Use exported variables for easy assignment in the editor.

---

## 📝 Example Usage

```gdscript
extends AnimationComponent

func _play_animation(animation: String) -> void:
	if animation_player and animation_player.has_animation(animation):
		animation_player.play(animation)

func _process_event(event: LocalEventData) -> void:
	if event.name == "state_changed":
		var anim = get_animation_for_state(event.data["new_state"])
		_play_animation(anim)

func get_animation_for_state(state: String) -> String:
	match state:
		"idle":
			return "idle_anim"
		"walk":
			return "walk_anim"
		_:
			return "idle_anim"
```

---

## 🛠️ Tips

- Always call `super._ready()` if you override `_ready()` in your script.
- Use the Inspector to assign dependencies for drag-and-drop setup.
- Use `_process_event` for filtering or preprocessing events before triggering animations.
- Use `_play_animation` for the actual animation logic.

---

## 📚 Related Base Classes

- `ComponentBase`: Handles event bus registration and event subscription.
- `AnimationComponentBase`: Exposes `animation_player` and `sprite_2d`, and enforces override of `_play_animation`.

---

## ❓ FAQ

**Q: What if I want to play different animations for different states or directions?**
A: Use a mapping or logic in your `_play_animation` or `_process_event` to select the correct animation name.

**Q: Can I use this for AnimatedSprite2D?**
A: Yes! Just add logic to control your `Sprite2D` or `AnimatedSprite2D` in your override methods.

---

## 🧑‍💻 For Future You

- This component is meant to be extended! Use it as a base for all animation logic in your entities.
- Keep your animation logic modular and event-driven for maximum flexibility.
