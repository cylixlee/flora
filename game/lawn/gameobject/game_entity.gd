extends PhysicObject
class_name GameEntity

var curr_health:int = 0##当前生命值
@export var init_health:int = 100##生成时基础血量
var extra_health:int = 0##额外生命值
var health_max:int = 100
@export var attack_power:int = 10##基础攻击力
var attack_power_add:float = 0##攻击力加算乘区
var attack_power_mult:float = 1##攻击力乘算乘区
@export var normal_resisit:float = 0##普通攻击抗性
@export var blast_resist:float = 0##爆炸抗性
@export var magic_resist:float = 0##魔法抗性
@export var crush_resist:float = 0##碾压抗性
@export var immunity_to_damage:int = 1##免疫这个值以下的伤害


@export var init_entity_tag:ENTITY_TAG = ENTITY_TAG.OTHER##初始实体标签，只能有一个，代表原始的阵容内容
##比如说被魅惑的僵尸，其init_entity_tag依旧是ZOMBIE
@export var curr_entity_tags:Array[int] = []##当前有哪些tag，包含ENTITY_TAG枚举类型,
##初始化时会自动添加一个init_entity_tag

@export var area_vision:int = 0##视线有几个格子长
@export var has_special_vision:bool = false ##是否具备特殊索敌，若为true则其索敌不会自动初始化
##一般来说，针对整行进行索敌的，以及全屏追踪类型，就属于特殊索敌类型
@export var visions:Array[Area2D] = []##视野，索敌用area2d
@export var fight_areas:Array[Area2D] = []##近战范围
@export var is_fight_vision:bool = true##是否直接使用近战范围来索敌

var enemy_type_list:Array[int]##具备那种entity_tag的会被视作敌人


func _ready():
	super()
	vision_area_init()
	


func vision_area_init():##索敌视野初始化
	if has_special_vision:
		return
	for _fight_area:Area2D in fight_areas:
		if is_fight_vision:
			visions.append(_fight_area)
		_fight_area.collision_layer = 2
		_fight_area.collision_mask = 1
	for _vision:Area2D in visions:
		_vision.collision_layer = 2
		_vision.collision_mask = 1

func find_enemy() ->bool:##查询自身索敌范围内是否有敌人，有就返回true
	if has_special_vision:
		return true
	else:
		var output:bool = false
		for _area:Area2D in visions:
			var _get_areas:Array[Area2D] = _area.get_overlapping_areas()
			for _get_area:Area2D in  _get_areas:
				var _entity = Game.tool.area_get_entity(_get_area)
				if _entity is GameEntity:
					if _entity.object_state == LawnObject.OBJECT_STATE.NORMAL:
						for _find_type:int in enemy_type_list:
							for _type:int in _entity.curr_entity_tags:
								if _find_type == _type and find_enemy_check_zheight(_entity):
									output = true
									break
		return output

func find_enemy_check_zheight(_entity:GameEntity):##未完工,关于目标实体的z轴高度是否符合自身可攻击范畴的判定
	return true
	
enum ENTITY_TAG{##实体标签，类似group
	PLANT,
	ZOMBIE,
	OTHER,
	PLANT_BULLET,
	ZOMBIE_BULLET,
	OTHER_BULLET,
	ZOMBIE_ARMOR,##僵尸护甲
}
