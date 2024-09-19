extends Node

#region Scene transitions
signal start_game()
signal enable_player()
#endregion

#region game manager signals
signal start_minigame(number_of_kids: int)
signal set_new_score(score: int)
#endregion

#region minigame signals
signal increase_minigame_score(point_type: GameManager.POINT_TYPE)
signal minigame_ended()
signal minigame_outcome(obtained_good_score: bool)
signal fail_hit()
signal broadcast_set_difficulty(difficulty: int)
#endregion

#region Kid Spawner signals
signal report_kids_in_area(spawner: Area2D, kids: Array[Kid])
#endregion

#region UI signals
signal hide_info_panel()
#endregion
