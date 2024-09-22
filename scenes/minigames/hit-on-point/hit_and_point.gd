extends Minigame

@export var min_score_baseline : int

@onready var timer : Timer = %Timer
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var animated_sprite_target : AnimatedSprite2D = %Target
@onready var animated_sprite_avatar : AnimatedSprite2D = %PlayerAvatar
@onready var spookometer : Control = %Spookometer

@onready var background_container : ColorRect = %Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.increase_minigame_score.connect(_on_increase_score.bind())
	SignalBus.fail_hit.connect(_on_failed_hit)
	timer.wait_time = 5 + number_of_kids
	min_score_baseline += GameManager.difficulty
	spookometer.min_score_to_win = min_score_baseline
	timer.start()
	animated_sprite_target.play("idle")
	animated_sprite_avatar.play("idle")
	
func _on_timer_timeout() -> void:
	GameManager.score = obtained_score
	SignalBus.increase_minigame_score.disconnect(_on_increase_score)
	if obtained_score >= min_score_baseline:
		SignalBus.minigame_outcome.emit(true)
	else:
		SignalBus.minigame_outcome.emit(false)
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
