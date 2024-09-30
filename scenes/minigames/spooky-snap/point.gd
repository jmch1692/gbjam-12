extends AnimatedSprite2D

@onready var _follow : PathFollow2D = %PathFollow2D
@onready var normal_particles : GPUParticles2D = %NormalParticles
@onready var perfect_particles : GPUParticles2D = %PerfectParticles

const speed_baseline : int = 18

var pointer_speed : float = 0 :
	set(value):
		pointer_speed = value * speed_baseline
		
var in_perfect_area : bool = false
var in_ok_area : bool = false
var started : bool = false

		
func _process(delta: float) -> void:
	if started:
		_follow.set_progress(_follow.get_progress() + pointer_speed * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a") && started:
		if in_ok_area and not in_perfect_area:
			SignalBus.increase_minigame_score.emit(GameManager.POINT_TYPE.HALF_POINT)
			normal_particles.emitting = true
		elif in_perfect_area and in_ok_area:
			perfect_particles.emitting = true
			SignalBus.increase_minigame_score.emit(GameManager.POINT_TYPE.FULL_POINT)
		else:
			SignalBus.fail_hit.emit()

func _on_target_area_normal_area_entered(area: Area2D) -> void:
	if area.name == "PointerArea":
		in_ok_area = true

func _on_target_area_perfect_area_entered(area: Area2D) -> void:
	if area.name == "PointerArea":
		in_perfect_area = true

func _on_target_area_normal_area_exited(area: Area2D) -> void:
	if area.name == "PointerArea":
		in_ok_area = false

func _on_target_area_perfect_area_exited(area: Area2D) -> void:
	if area.name == "PointerArea":
		in_perfect_area = false
