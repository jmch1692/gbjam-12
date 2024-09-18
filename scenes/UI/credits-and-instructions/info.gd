extends Control

@export_multiline var text : String = ""
@export var title : String = ""

@onready var title_label : Label = %Label
@onready var text_control : RichTextLabel = %RichTextLabel
@onready var back_button : Button = %Button

func _ready() -> void:
	text_control.text = text
	title_label.text = title
	back_button.grab_focus()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("b"):
		_on_button_pressed()

func _on_button_pressed() -> void:
	SignalBus.hide_info_panel.emit()
	hide()
