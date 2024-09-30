extends Control

@onready var icon : TextureRect = $Icon

var is_revealed : bool = false

func _ready() -> void:
	icon.modulate.a = 0.0
