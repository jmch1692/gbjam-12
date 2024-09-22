class_name InactiveState
extends StateMachineState

# Called when the state machine enters this state.
func on_enter() -> void:
	SignalBus.minigame_outcome.connect(_on_minigame_ended.bind())
	state_machine.animation_player.play("Idle")

func _on_minigame_ended(won: bool):
	if won:
		state_machine.change_state("Transform")
	else:
		state_machine.change_state("Idle")
	
func on_exit() -> void:
	SignalBus.minigame_outcome.disconnect(_on_minigame_ended)
