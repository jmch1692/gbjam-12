extends Control

var min_score_to_win : int = 0
var current_score : int = 0
var bar_height : int = 0
var indicator_position : int = 0

@onready var indicator : Sprite2D = $Indicator
@onready var bar : Sprite2D = $Tube
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SignalBus.increase_minigame_score.connect(_on_increase_minigame_score.bind())
	bar_height = bar.position.distance_to(indicator.position)
	indicator_position = indicator.position.y

func _on_increase_minigame_score(point_type: GameManager.POINT_TYPE):
	current_score += GameManager.scoring_map[point_type]
	animation_player.play("shake")
	# Calculate progress as a ratio between current score and the max scores
	var progress_ratio: float = float(current_score) / float(min_score_to_win)
	progress_ratio = clamp(progress_ratio, 0.0, 1.0)
	
	var new_indicator_position: float = indicator_position - (progress_ratio * bar_height)
	
	var tween : Tween = create_tween()
	tween.tween_property(indicator, "position:y", new_indicator_position, 1.0).set_ease(Tween.EASE_OUT)
