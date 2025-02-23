extends Node2D
class_name Level

#=== 常量 ===
const LEVEL_PATH: String = "res://game/lawn/level/level/level.tscn"

#=== 代码运行有关变量 ===
@onready var entity_layer: Array[Node2D] = [$EntityLayer/Layer0, $EntityLayer/Layer1, $EntityLayer/Layer2, \
										   $EntityLayer/Layer3, $EntityLayer/Layer4, $EntityLayer/Layer5]##实体图层数组

#=== 游戏内容类型变量 ===
## 初始阳光
var initial_sun: int = 50
## 关卡名称
var level_name: String = "MISSING"
## 关卡的数字名称
var level_num: int = 0
## 是否有选卡
var player_choose: bool = true
## 生存模式总局数，若为-1则为无尽模式
var survival_max_value: int = 1
## 当前生存模式为第几轮，若等于max_value则判定关卡胜利
var survival_curr_value: int = 0


static func enter(level_info: LevelInfo):
	var level_path: String = level_info.terria_scene_path
	if FileAccess.file_exists(level_path):
		Game.get_tree().change_scene_to_file(level_path)
	else:
		Game.get_tree().change_scene_to_file(LEVEL_PATH)
	var new_level: Level = Game.get_tree().get_first_node_in_group("level")
	new_level.level_set_value(level_info)


func _ready():
	add_to_group("level")


func level_set_value(level_info: LevelInfo): ##关卡参数设置函数
	initial_sun = level_info.sun_value
	level_name = level_info.level_name
	level_num = level_info.level_num
	player_choose = level_info.player_choose
	
