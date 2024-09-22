extends CharacterBody2D
class_name Kid

@onready var animator : AnimatedSprite2D = $Animator
@onready var speech_bubble : PackedScene = preload("res://scenes/UI/speech-bubble/speech_bubble.tscn")
@onready var marker : Marker2D = $Marker2D
@onready var timer : Timer = $Timer

var player : CharacterBody2D
var costume_worn : String = ""

var spoken : bool = false
var afraid : bool = true

enum COSTUME {
	WITCH,
	GHOST,
	SKELEKID,
	MUMMY
}

func _ready() -> void:
	SignalBus.minigame_outcome.connect(_on_minigame_outcome.bind())
	SignalBus.scare_away.connect(_on_scare_away.bind())

func _on_scare_away(area: Area2D) -> void:
	animator.play(costume_worn + "-scared")

func _on_minigame_outcome(won: bool):
	if !won:
		animator.play(costume_worn + "-laugh")
		afraid = false
		timer.start()
	
func put_on_costume(costume : String):
	costume_worn = str(costume.to_lower())
	animator.play(costume_worn)
	animator.speed_scale = randf_range(0.6, 1)
	
func show_dialogue():
	if not spoken and afraid:
		var speech_bubble = speech_bubble.instantiate()
		speech_bubble.position = marker.position
		add_child(speech_bubble)
		spoken = true

func _on_timer_timeout() -> void:
	afraid = true

func _on_animator_animation_finished() -> void:
	var animation_name = animator.animation.get_basename()
	if animation_name.ends_with("-laugh"):
		animator.play(costume_worn)
		animator.speed_scale = randf_range(0.6, 1)
	elif animation_name.ends_with("-scared"):
		animator.flip_h = [true, false].pick_random()
		animator.play(costume_worn + "-run")
	elif animation_name.ends_with("-run"):
		queue_free()
		
