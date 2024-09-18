extends Control

var obtained_score : int = 0
var number_of_kids : int = 0

@export var min_score_baseline : int

@onready var timer : Timer = %Timer
@onready var animated_sprite : AnimatedSprite2D = %PlayerAvatar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.increase_minigame_score.connect(_on_increase_score.bind())
	timer.wait_time = 5 + number_of_kids
	timer.start()
	animated_sprite.play("Idle")
	

func _on_timer_timeout() -> void:
	GameManager.score = obtained_score
	SignalBus.increase_minigame_score.disconnect(_on_increase_score)
	if obtained_score >= min_score_baseline:
		SignalBus.minigame_outcome.emit(true)
	else:
		SignalBus.minigame_outcome.emit(false)
	SignalBus.minigame_ended.emit()
	queue_free()

func _on_increase_score(point_type: GameManager.POINT_TYPE):
	obtained_score += GameManager.scoring_map[point_type]
