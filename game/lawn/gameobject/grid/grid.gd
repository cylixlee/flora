extends PhysicObject
class_name Grid
##grid_dic的范例
const GRID_DIC:Dictionary = {
	"init_pos":[0,0]
}


static func create_grid(grid_dic:Dictionary):
	if Game.level_manager.curr_level:
		var bg_layer:Node2D = Game.level_manager.curr_level.bg_layer
		var new_grid:Grid = Grid.create_from_gamescenes("OTHER","Grid",bg_layer)
		





enum GRID_TYPE{
	NONE,##虚空
	GRASS,##草皮，允许种植
	DISABLE,##禁用，往往使用在地块被非植物，僵尸的实体占据时
	OCCUPY,##其他chessentity实体占用
	WATER,##水
	LAVA,##熔岩
	BARE,##裸地
}


class _single_grid:
	var grid_change_entity:Array[ChessEntity] = []##地形改变类chessentity放在这个数组里
	var main_entity:Array[ChessEntity] = []##主要类型chessentity放在这个数组里
	var shell_entity:Array[ChessEntity] = []##外壳类型chessentity在这个数组里
	var flying_entity:Array[ChessEntity] = []##飞行类型chessentity
	var grid_type:Array[int] = []##地形数组，一般他的第0个元素是原始地形数据
	var grid_change_max:int = 2
	var main_max:int = 1
	var shell_max:int = 1
	var flying_max:int = 4
	
	
