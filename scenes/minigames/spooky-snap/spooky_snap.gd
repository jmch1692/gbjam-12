extends Minigame

@export var min_score_baseline : int

@onready var timer : Timer = %Timer
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var animated_sprite_target : AnimatedSprite2D = %Target
@onready var animated_sprite_avatar : AnimatedSprite2D = %PlayerAvatar
@onready var spookometer : Control = %Spookometer
@onready var pointer : AnimatedSprite2D = %Point

func _init() -> void:
	game_name = "Spooky Snap"
	instructions = """
	Wait for the pumpkins to align properly and press 'A' to collect candy. \nThe more precise, the more candies you get!
	"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.increase_minigame_score.connect(_on_increase_score.bind())
	SignalBus.fail_hit.connect(_on_failed_hit)
	SignalBus.minigame_countdown_timeout.connect(_on_minigame_countdown_timeout)
	timer.wait_time = 5 + number_of_kids
	min_score_baseline += difficulty
	spookometer.min_score_to_win = min_score_baseline
	animated_sprite_target.play("idle")
	animated_sprite_avatar.play("idle")
	SignalBus.set_title_and_instructions.emit(game_name, instructions)
	
func _on_minigame_countdown_timeout() -> void:
	var player : CharacterBody2D = get_tree().get_first_node_in_group("main")
	var closest_area = player.closest_area
	number_of_kids = GameManager.kids_and_areas[closest_area].size()
	difficulty = (1 + difficulty_scaling_speed) * number_of_kids
	pointer.started = true
	pointer.pointer_speed = difficulty
	timer.start()
	
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
