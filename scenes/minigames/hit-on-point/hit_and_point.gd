extends Control

var obtained_score : int = 0
var number_of_kids : int = 0

@export var min_score_baseline : int

@onready var timer : Timer = %Timer
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var animated_sprite_target : AnimatedSprite2D = %Target
@onready var animated_sprite_avatar : AnimatedSprite2D = %PlayerAvatar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.increase_minigame_score.connect(_on_increase_score.bind())
	SignalBus.fail_hit.connect(_on_failed_hit)
	SignalBus.broadcast_set_difficulty.connect(_on_broadcast_set_difficulty.bind())
	timer.wait_time = 5 + number_of_kids
	timer.start()
	animated_sprite_target.play("idle")
	animated_sprite_avatar.play("idle")
	
func _on_broadcast_set_difficulty(difficulty: int):
	min_score_baseline += difficulty
	print("You need to hit at least " + str(min_score_baseline) + " points to win this minigame")
	
func _on_timer_timeout() -> void:
	GameManager.score = obtained_score
	SignalBus.increase_minigame_score.disconnect(_on_increase_score)
	if obtained_score >= min_score_baseline:
		SignalBus.minigame_outcome.emit(true)
	else:
		SignalBus.minigame_outcome.emit(false)
	SignalBus.minigame_ended.emit()
	queue_free()
	
func _on_failed_hit():
	animated_sprite_target.stop()
	animated_sprite_avatar.stop()
	animated_sprite_target.play("fail")
	animation_player.play("shake_on_fail")
	animated_sprite_avatar.play("mad")

func _on_increase_score(point_type: GameManager.POINT_TYPE):
	animated_sprite_target.stop()
	animated_sprite_avatar.stop()
	animated_sprite_target.play("hit")
	animated_sprite_avatar.play("happy")
	obtained_score += GameManager.scoring_map[point_type]
