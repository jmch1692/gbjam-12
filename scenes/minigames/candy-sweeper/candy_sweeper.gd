extends Minigame

@warning_ignore("integer_division")

@onready var texture : Texture = preload("res://art/particles/candy-orange.png")
@onready var bad_texture : Texture = preload("res://art/minigame_candy_sweeper/pumpkin-16x16.png")
@onready var surprise_box : PackedScene = preload("res://scenes/minigames/candy-sweeper/sweeper_box.tscn")
@onready var grid : GridContainer = %GridContainer
@onready var selector : TextureRect = %Selector
@onready var spookometer : Control = %Spookometer

@export var rows : int = 4
@export var chance : float = 0.35

var number_of_elements : int = 0
var min_score_baseline : int
var elements : Dictionary
var element_pointer : int = 0
var started = false
var boxes_containing_pumpkins : int

var allowed_bad_hits : int : 
	set(value):
		allowed_bad_hits = value
		if allowed_bad_hits <= 0:
			finish_game()

func fill_container() -> void:
	number_of_elements = rows * grid.columns
	for cell in number_of_elements:
		var surprise_box_instantiated = surprise_box.instantiate()
		grid.add_child(surprise_box_instantiated)
		
func _init() -> void:
	game_name = "Candy Sweeper"
	instructions = """
	Select a box with 'A'. Find the candies, avoid the pumpkins
	"""

func _ready() -> void:
	SignalBus.minigame_countdown_timeout.connect(_on_minigame_countdown_timeout)
	randomize()
	fill_container()
	number_of_elements = grid.get_child_count()
	
	for element in number_of_elements:
		var item : TextureRect = grid.get_child(element).get_child(0)
		if randf() < chance:
			item.texture = texture
			elements[item] = { "is_occupied" : true }
		else:
			item.texture = bad_texture
			boxes_containing_pumpkins += 1
			
	SignalBus.set_title_and_instructions.emit(game_name, instructions)
		
func calculate_allowed_bad_hits(bad_choices: int) -> int:
	
	var max_hits = max(1, floor(bad_choices/log(number_of_kids + difficulty_scaling_speed)))
	
	return max(1, max_hits)
	
func _input(event: InputEvent) -> void:
	if started:
		var horizontal_axis = Input.get_axis("left", "right")
		var vertical_axis = Input.get_axis("up", "down")
	
		# Horizontal movement
		if horizontal_axis != 0:
			var new_pointer = element_pointer + int(horizontal_axis)
			
			# Ensure pointer stays within valid horizontal bounds
			if new_pointer >= 0 and new_pointer < number_of_elements and (new_pointer / grid.columns == element_pointer / grid.columns):
				element_pointer = new_pointer
				selector.position = grid.get_child(element_pointer).global_position
		
		# Vertical movement
		if vertical_axis != 0:
			var new_pointer = element_pointer + int(vertical_axis) * grid.columns
			
			# Ensure pointer stays within valid vertical bounds
			if new_pointer >= 0 and new_pointer < number_of_elements:
				element_pointer = new_pointer
				selector.position = grid.get_child(element_pointer).global_position
			
	if Input.is_action_just_pressed("a") && started:
		var selected_item : TextureRect = grid.get_child(element_pointer)
		if !selected_item.is_revealed:
			var icon = selected_item.get_child(0)
			var tween : Tween = create_tween()
			tween.tween_property(icon, "modulate:a", 1.0, 0.5)
			selected_item.is_revealed = true
			if icon.texture == bad_texture:
				SignalBus.fail_hit.emit()
				allowed_bad_hits -= 1
			else:
				SignalBus.increase_minigame_score.emit(GameManager.POINT_TYPE.FULL_POINT)
				obtained_score += GameManager.scoring_map[GameManager.POINT_TYPE.FULL_POINT]

func _on_minigame_countdown_timeout() -> void:
	var player : CharacterBody2D = get_tree().get_first_node_in_group("main")
	var closest_area = player.closest_area
	number_of_kids = GameManager.kids_and_areas[closest_area].size()
	min_score_baseline = GameManager.scoring_map[GameManager.POINT_TYPE.FULL_POINT] * number_of_kids
	spookometer.min_score_to_win = min_score_baseline
	allowed_bad_hits = calculate_allowed_bad_hits(boxes_containing_pumpkins)
	started = true
	chance = max((number_of_kids / 16), 1)
	
func finish_game() -> void:
	GameManager.score = obtained_score
	if obtained_score >= min_score_baseline:
		SignalBus.minigame_outcome.emit(true)
	else:
		SignalBus.minigame_outcome.emit(false)
	queue_free()
