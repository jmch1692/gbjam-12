extends Node

@onready var map : PackedScene = preload("res://scenes/map/map.tscn")
@onready var minigame_instructions : PackedScene = preload("res://scenes/UI/minigame-instructions/instructions.tscn")
@onready var minigame_counter : PackedScene = preload("res://scenes/UI/mini-game-countdown/countdown.tscn")

const half_point : int = 4

enum POINT_TYPE {
	CONSOLATION_POINT,
	HALF_POINT,
	FULL_POINT
}

var scoring_map : Dictionary = {
	POINT_TYPE.CONSOLATION_POINT : half_point / 2,
	POINT_TYPE.HALF_POINT: half_point,
	POINT_TYPE.FULL_POINT: half_point * 2
}

var kids_and_areas : Dictionary
var randomizer : RandomNumberGenerator = RandomNumberGenerator.new()

var minigame_details : Dictionary  = {
	"game_title": "",
	"game_instructions": ""
}
var minigame_cooldown : bool = false :
	set(value):
		if value == true:
			minigame_cooldown = true
			await get_tree().create_timer(5.0).timeout
			minigame_cooldown = false

var score : int = 0 :
	set(value):
		score += value
		SignalBus.set_new_score.emit(score)
	get:
		return score
		
var minigames : Array[PackedScene] = [
	preload("res://scenes/minigames/spooky-snap/spooky_snap.tscn")
]
	
func _ready():
	randomizer.randomize()
	SignalBus.setup_minigame.connect(_on_setup_minigame)
	SignalBus.clear_area.connect(_on_clear_area.bind())
	SignalBus.report_kids_in_area.connect(_on_report_kids_in_area.bind())
	SignalBus.minigame_outcome.connect(_on_minigame_outcome.bind())
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.cancel_out_minigame.connect(_on_cancel_out_minigame)
	SignalBus.set_title_and_instructions.connect(_on_set_title_and_instructions.bind())

func _on_set_title_and_instructions(title: String, instructions: String) -> void:
	minigame_details = {
		"game_title": title,
		"game_instructions": instructions
	}

func _on_cancel_out_minigame() -> void:
	var minigame_setup_nodes = get_tree().get_nodes_in_group("minigame")
	for scene in minigame_setup_nodes:
		scene.queue_free()
	minigame_details.clear()
	SignalBus.enable_player.emit()

func _on_minigame_outcome(won: bool):
	if !won:
		minigame_cooldown = true

func _on_clear_area(area: Area2D):
	var player : CharacterBody2D = get_tree().get_first_node_in_group("main")
	var closest_area = player.closest_area
	kids_and_areas.erase(closest_area)
	player.closest_area = null

func get_number_of_kids_in_area(area : Area2D) -> int:
	var kids = kids_and_areas[area]
	return kids.size()

func _on_setup_minigame() -> void:
	var minigame_counter_scene = minigame_counter.instantiate()
	var minigame_instructions_instantiated = minigame_instructions.instantiate()
	var minigame_scene = minigames.pick_random().instantiate()
	var root_node = get_tree().root
	root_node.add_child(minigame_scene)
	root_node.add_child(minigame_counter_scene)
	root_node.add_child(minigame_instructions_instantiated)

	
func _on_start_game():
	var map_nstance = map.instantiate()
	add_sibling(map_nstance)

func _on_report_kids_in_area(area: Area2D, kids: Array[Kid]):
	kids_and_areas[area] = kids

func make_random_kid_talk(area : Area2D):
	var kids = get_number_of_kids_in_area(area)
	for kid in kids:
		var chance = randomizer.randi_range(0, kids)
		if chance < 1:
			kids_and_areas[area][chance].show_dialogue()
