extends Node2D
class_name Level

#=== 常量 ===
const LEVEL_PATH: String = "res://game/lawn/level/scene/level.tscn"

#=== 代码运行有关变量 ===
@onready var entity_layer: Array[Node2D] = [$EntityLayer/Layer0,$EntityLayer/Layer1,
$EntityLayer/Layer2,$EntityLayer/Layer3,$EntityLayer/Layer4,$EntityLayer/Layer5]##实体图层数组
@onready var bg_layer: Node2D = $BackGroundLayer
@onready var collect_layer: Node2D = $CollectLayer

@onready var bg_sprite:Sprite2D = $BackGroundLayer/BackGroundSprite
@onready var grids_upleft_pos:Vector2 = $BackGroundLayer/BackGroundSprite/MarkerUpLeft.global_position
@onready var grids_downright_pos:Vector2 = $BackGroundLayer/BackGroundSprite/MarkerDownRight.global_position
@export var grids_row:int = 7
@export var grids_column:int = 9

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
##===============================================================================
var GRAVITY_VALUE:float = 10.0##重力参数


signal init_finish(_level:Level)##关卡初始化完成的信号
signal level_finish(_finish_flag:bool)##未完工，关卡彻底结束的信号,发射他代表要进行场景跳转了
static func enter(level_info: LevelInfo):
	Game.level_manager.enter_level(level_info)


func _ready():
	connect("init_finish",Game.level_manager.new_level_init,CONNECT_ONE_SHOT)
	connect("level_finish",Game.level_manager.finish_level,CONNECT_ONE_SHOT)
	
	
	init_finish.emit(self)


func level_set_value(level_info: LevelInfo): ##关卡参数设置函数
	initial_sun = level_info.sun_value
	level_name = level_info.level_name
	level_num = level_info.level_num
	player_choose = level_info.player_choose
	
