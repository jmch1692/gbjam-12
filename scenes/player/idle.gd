class_name IdleState
extends StateMachineState

# Called when the state machine enters this state.
func on_enter() -> void:
	state_machine.animation_player.play("Idle")
#
## Called every frame when this state is active.
#func on_process(delta: float) -> void:
	#pass
#
## Called every physics frame when this state is active.
#func on_physics_process(delta: float) -> void:
	#pass

# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		state_machine.change_state("Move")

	if event.is_action_pressed("a") && owner.closest_area != null && !GameManager.minigame_cooldown:
		SignalBus.setup_minigame.emit()
		state_machine.change_state("Inactive")
		
## Called when the state machine exits this state.
#func on_exit() -> void:
	#pass
