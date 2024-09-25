extends Node

#region Scene transitions
signal start_game()
signal enable_player()
#endregion

#region game manager signals
signal set_new_score(score: int)
signal setup_minigame()
#endregion

#region minigame signals
signal increase_minigame_score(point_type: GameManager.POINT_TYPE)
signal minigame_outcome(obtained_good_score: bool)
signal fail_hit()
signal minigame_countdown_timeout()
signal instructions_read_and_ready()
signal set_title_and_instructions(title: String, instructions: String)
signal cancel_out_minigame()
#endregion

#region Kid Spawner signals
signal report_kids_in_area(spawner: Area2D, kids: Array[Kid])
signal player_within_this_spook_area(area: Area2D)
signal player_left_this_spook_area(area: Area2D)
signal clear_area(area: Area2D)
#endregion

#region Kid signals
signal remove_kid(kid: Kid)
#endregion

#region UI signals
signal hide_info_panel()
#endregion
