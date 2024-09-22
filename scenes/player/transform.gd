extends StateMachineState
class_name TransformState

## Called when the state machine enters this state.
func on_enter() -> void:
	state_machine.animation_player.play("transform")
	state_machine.animation_player.animation_finished.connect(_on_animation_finished.bind())
	SignalBus.scare_away.emit(owner.closest_area)

func _on_animation_finished(anim_name: String):
	if anim_name == "transform":
		state_machine.change_state("Idle")

# Called when the state machine exits this state.
func on_exit() -> void:
	state_machine.animation_player.animation_finished.disconnect(_on_animation_finished)
