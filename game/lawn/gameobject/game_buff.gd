extends RefCounted
class_name game_buff
##游戏内实体对其他实体施加影响，必须通过传递这个类来实现
##尽量不要继承这个类型

var damage:int = 0##伤害
var damge_type:DAMAGE_TYPE = DAMAGE_TYPE.NORMAL
var is_continue:bool = false##是否具有持续性,若为false，则目标entity不会存储对它的引用，施加一次影响后会自行free
##若为true说明有可持续性



enum DAMAGE_TYPE{##伤害类型
	NORMAL,##普通
	BLAST,##爆炸
	MAGIC,##魔法
	CRUSH,##碾压
}
