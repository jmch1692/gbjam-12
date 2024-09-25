extends StateMachineState
class_name TransformState

## Called when the state machine enters this state.
func on_enter() -> void:
	state_machine.animation_player.play("transform")
	state_machine.animation_player.animation_finished.connect(_on_animation_finished.bind())
	for kid: Kid in GameManager.kids_and_areas[owner.closest_area]:
		if kid.has_method("make_afraid"):
			kid.make_afraid()

func _on_animation_finished(anim_name: String):
	if anim_name == "transform":
		for kid: Kid in GameManager.kids_and_areas[owner.closest_area]:
			if kid.has_method("scare_away"):
				kid.scare_away()
		state_machine.change_state("Idle")

# Called when the state machine exits this state.
func on_exit() -> void:
	state_machine.animation_player.animation_finished.disconnect(_on_animation_finished)
