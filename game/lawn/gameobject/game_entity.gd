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



func _ready():
	super()
	


#func vision_area_init():##索敌视野初始化
	#if not has_special_vision:
		#pass
	#if is_fight_vision:
		#for _fight_area:Area2D in fight_areas:
			#visions.append(_fight_area)
	#for _vision:Area2D in visions:
		#pass



	
enum ENTITY_TAG{##实体标签，类似group
	PLANT,
	ZOMBIE,
	OTHER,
	PLANT_BULLET,
	ZOMBIE_BULLET,
	OTHER_BULLET,
	ZOMBIE_ARMOR,##僵尸护甲
}
