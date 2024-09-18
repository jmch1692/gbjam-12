extends CharacterBody2D
class_name Kid

@onready var animator : AnimatedSprite2D = $Animator
@onready var speech_bubble : PackedScene = preload("res://scenes/UI/speech-bubble/speech_bubble.tscn")
@onready var marker : Marker2D = $Marker2D

var player : CharacterBody2D

var spoken : bool = false

enum COSTUME {
	WITCH,
	GHOST,
	SKELEKID
}

func _on_minigame_outcome(won: bool):
	if !won:
		print("laugh!")
	
func put_on_costume(costume : String):
	animator.play(costume.to_lower())
	
func show_dialogue():
	if not spoken:
		var speech_bubble = speech_bubble.instantiate()
		speech_bubble.position = marker.position
		add_child(speech_bubble)
		spoken = true
