extends Control

@onready var dialogue_text : RichTextLabel = $ColorRect/DialogueText
@onready var box : ColorRect = $ColorRect
@onready var timer : Timer = %Timer

const y_offset : int = 12
const x_offset : int = 40

var possible_dialogues : Array[String] = [
	"I'm the spookiest this year...",
	"Who...what are you?",
	"I've got soooo many candies!",
	"My tummy... it hurts...",
	"Hey! Your costume is aweeesome!",
	"Wanna trade some candies?",
	"Hurry up! There's so many houses left to visit!",
	"This is the lamest halloween",
	"Need...more....candy",
	"Nothing can scare us if we stick together",
	"Not scary, try again later!",
	"Let's stick together, otherwise, we'll be easier to scare"
]

func _ready() -> void:
	dialogue_text.text = possible_dialogues.pick_random()
	dialogue_text.visible_characters = 0
	var typing_tween : Tween = create_tween()
	typing_tween.parallel().tween_property(box, "size:y", box.size.y + dialogue_text.get_total_character_count() + y_offset, 0.5)
	typing_tween.parallel().tween_property(box, "size:x", box.size.x + dialogue_text.get_total_character_count() + x_offset, 0.5)
	typing_tween.parallel().tween_property(dialogue_text, "visible_characters", dialogue_text.get_total_character_count(), 2.0)
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
