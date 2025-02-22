extends Resource
class_name LevelInfo

@export var sun_value:int = 1000
@export var level_name:String = "missing"
@export var level_num:int = 0
@export var zombie_spawn_pool:Array[String] = []##僵尸刷怪类型池，若为空则会尝试自动从刷怪文件中加载
@export var player_choose:bool = true##是否有玩家选卡过程
@export var locked_seed:Array[SeedSave] = []##锁定选卡的卡组，若为空就是完全自由选卡
@export var has_convey:bool = false##是否有传送带
##@export var convey_mode:CONVEY_MODE##传送带详细设置，未完成
@export var win_mode:Dictionary##记录特定格式的字典,键值为“胜利条件：监听事件类型”，数值为数组，内部包含参数（建立一个事件监听器的目标
##只能有一个参数,数组有多大就代表建立几个事件监听器）
@export var level_anim:Dictionary##关卡动画信息
@export var terria_scene_path:String##指向对应地形的tscn文件的文件路径
@export var level_type_path:String##关卡背景图片路径##建议不要使用这个,用terria_scene_path更好
@export var gameobj_pre_set:Dictionary##需要预先在关卡里放置的实体信息，以实体注册名为键值，内容为一个字典，内部包含一个建立实体的
#Dictionary（data为键值）以及一个四元数组用来规定位置范围(如[0,0]到[0,0]就是仅生成在【0,0】,[0,0]到[1,1]就是生成在
#[0,0],[0,1],[1,0],[1,1]（pos为键值）
@export var music_type_path:Array[String]##背景音乐的路径写在数组里面，音乐会伴随阶段来切换
@export var survive_value:int ##生存模式局数，一般情况下为1,若设置为-1就是无尽模式
@export var AI_entity_spawn:Array[Dictionary]##内部记载每一局的刷怪文件(dictionary形式),生存模式有多少局给多少dictionary
@export var grid_value:Dictionary##记载草坪格子类型
