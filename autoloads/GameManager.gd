extends Node

@onready var minigame_hit_point : PackedScene = preload("res://scenes/minigames/hit-on-point/hit-and-point.tscn")
@onready var map : PackedScene = preload("res://scenes/map/map.tscn")

const half_point : int = 4
const difficulty_scaling_speed : int = 2

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

var difficulty : int
var kids_and_areas : Dictionary
var randomizer : RandomNumberGenerator = RandomNumberGenerator.new()

var score : int = 0 :
	set(value):
		score += value
		SignalBus.set_new_score.emit(score)
	get:
		return score
		
func _on_start_game():
	var map = map.instantiate()
	add_sibling(map)

func _ready():
	randomizer.randomize()
	SignalBus.start_minigame.connect(_on_start_minigame.bind())
	SignalBus.minigame_outcome.connect(_on_minigame_outcome.bind())
	SignalBus.report_kids_in_area.connect(_on_report_kids_in_area.bind())
	SignalBus.start_game.connect(_on_start_game)

func _on_minigame_outcome(won: bool):
	var player : CharacterBody2D = get_tree().root.get_node("./Map/Player")
	var closest_area = player.closest_area
	if player.closest_area:
		if won:
			#TODO: Animate kids to run away
			kids_and_areas.erase(player.closest_area)
			closest_area.queue_free()
			player.closest_area = null

func get_number_of_kids_in_area(area : Area2D) -> int:
	var kids = kids_and_areas[area]
	return kids.size()
	
func _on_start_minigame(number_of_kids : int):
	difficulty = (1 + difficulty_scaling_speed) * number_of_kids
	var root_node = get_tree().root
	var minigame = minigame_hit_point.instantiate()
	minigame.number_of_kids = number_of_kids
	root_node.add_child(minigame)

func _on_report_kids_in_area(area: Area2D, kids: Array[Kid]):
	kids_and_areas[area] = kids

func make_random_kid_talk(area : Area2D):
	var kids = get_number_of_kids_in_area(area)
	for kid in kids:
		var chance = randomizer.randi_range(0, kids)
		if chance < 1:
			kids_and_areas[area][chance].show_dialogue()
