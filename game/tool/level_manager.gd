extends Node
class_name LevelManager
##关卡控制相关
const LEVEL_PATH: String = "res://game/lawn/level/scene/level.tscn"
var curr_level:Level
var curr_level_info:LevelInfo
var last_scene:Node##上一个场景

func enter_level(_level_info:LevelInfo):
	var level_path: String = _level_info.terria_scene_path
	if FileAccess.file_exists(level_path):
		get_tree().change_scene_to_file(level_path)
	else:
		get_tree().change_scene_to_file(LEVEL_PATH)
	curr_level_info = _level_info
	##level会在ready好之后发射信号触发new_level_init函数

func new_level_init(_level:Level):
	curr_level = _level
	_level.level_set_value(curr_level_info)
	
	
func finish_level(_finish_flag:bool):
	curr_level = null
	curr_level_info = null
