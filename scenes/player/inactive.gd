class_name InactiveState
extends StateMachineState

# Called when the state machine enters this state.
func on_enter() -> void:
	SignalBus.minigame_ended.connect(_on_minigame_ended)

func _on_minigame_ended():
	state_machine.change_state("Idle")
	
func on_exit() -> void:
	SignalBus.minigame_ended.disconnect(_on_minigame_ended)
