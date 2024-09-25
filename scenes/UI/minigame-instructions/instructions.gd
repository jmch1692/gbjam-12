extends Control
class_name InstructionsScreen

@onready var next_button : Button = %Button
@onready var title_label : Label = %Title
@onready var instructions_label : RichTextLabel = %RichTextLabel 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_button.grab_focus()
	set_text(GameManager.minigame_details["game_title"], GameManager.minigame_details["game_instructions"])

func _on_button_pressed() -> void:
	SignalBus.instructions_read_and_ready.emit()
	queue_free()
	
func set_text(title: String, instructions: String) -> void:
	set_instructions(instructions)
	set_title(title)

func set_title(new_title: String) -> void:
	title_label.text = new_title
	
func set_instructions(instructions_text: String) -> void:
	instructions_label.text = instructions_text

func _on_cancel_pressed() -> void:
	SignalBus.cancel_out_minigame.emit()
	queue_free()
