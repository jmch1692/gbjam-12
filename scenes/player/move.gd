class_name MoveState
extends StateMachineState

@export var speed : float = 1.0
@export var spook_distance : float = 5000.0

# Called every frame when this state is active.
func on_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		state_machine.change_state("Idle")
	
	match direction:
		Vector2.RIGHT:
			state_machine.animation_player.play("MoveRight")
		Vector2.LEFT:
			state_machine.animation_player.play("MoveLeft")
	# stop diagonal movement by listening for input then setting axis to zero
	if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
		direction.y = 0
	elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
		direction.x = 0
		
	owner.velocity = direction * speed
	owner.move_and_slide()
	owner.closest_area = _check_closest_kid_area()

func _check_closest_kid_area() -> Area2D:
	var areas : Array = GameManager.kids_and_areas.keys()
	
	if areas.is_empty():
		return null
	
	for area in areas:
		if area.position.distance_squared_to(owner.position) <= spook_distance:
			GameManager.make_random_kid_talk(area)
			return area
		else:
			continue
	return null
	
# Called every physics frame when this state is active.
#func on_physics_process(delta: float) -> void:
	#pass
#
#
# Called when there is an input event while this state is active.
#func on_input(event: InputEvent) -> void:

#
#
## Called when the state machine exits this state.
#func on_exit() -> void:
	#pass
