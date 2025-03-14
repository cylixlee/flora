extends PhysicObject
class_name Grid
##grid的global_position就是左上角坐标
##grid_dic的范例
const GRID_DIC:Dictionary = {
	"use_global_pos":false,##使用绝对全局位置
	"global_pos_upleft":[100,100],##全局位置，左上角
	"init_pos":[0,0],##初始相对位置,
	"size":[1,1],##大小，[1,1]代表1*1,[1,9]代表1行9列
	"fast_layout":true,##快速部署模式，如果为true，则会将fast_layout_type对应的地面类型铺满整个grid
	"fast_layout_type":1,
	"skew_angle":0,##倾斜角度，保证右侧边缘与不倾斜时一致
	"type_array":[[]]
}

var single_grids:Array = []##二维数组

var grid_velocity:float = 0.0
var grid_direction:Vector2 = Vector2(1,0):set = set_grid_direction,get = get_grid_direction
func set_grid_direction(_vec:Vector2):
	grid_direction = _vec.normalized()
func get_grid_direction() -> Vector2:
	return grid_direction.normalized()

const Z_HEIGHT_FACTOR:float = 1##从global_position的offset转译成z_height的offset用的参数
const GRID_PATH:String = "res://game/lawn/gameobject/grid/grid.tscn"

signal grid_init_finish
func _ready():
	super()
	connect("left_mousebutton_pressed",grid_clicked_mouseleft)


static func create_grid(_grid_dic:Dictionary,_single_grid_size:Vector2) ->Grid:
	if Game.level_manager.curr_level:
		var bg_layer:Node2D = Game.level_manager.curr_level.bg_layer
		var new_grid:Grid = Grid.create_from_gamescenes("OTHER","grid",bg_layer)
		if _grid_dic["use_global_pos"]:
			pass
		else:
			var _init_pos:Vector2 = Game.level_manager.curr_level.grid_manager.get_upleft_pos_from_dot(_grid_dic["init_pos"])
			new_grid.global_position = _init_pos
		var _row:int = _grid_dic["size"][0]
		var _colomn:int = _grid_dic["size"][1]
		for i:int in range(0,_row):
			var _new_row:Array[_single_grid] = []
			for j:int in range(0,_colomn):
				_new_row.append(_single_grid.create(0))
			new_grid.single_grids.append(_new_row)
		
		new_grid.collect_area = Vector2(float(_colomn)*_single_grid_size.x,float(_row)*_single_grid_size.y)
		new_grid.center_marker.position += new_grid.collect_area*0.5
		new_grid.clct_area_skew_angle = float(_grid_dic["skew_angle"])
		new_grid.create_single_grids(_grid_dic["fast_layout"],_grid_dic["fast_layout_type"],_grid_dic["type_array"])
		
		new_grid.grid_init_finish.emit()
		return new_grid
	else:
		return load(GRID_PATH).instantiate()	

func create_single_grids(_fast_layout:bool,_fast_type:GRID_TYPE,_type_array:Array = []):
	if _fast_layout:
		for _row:Array[_single_grid] in single_grids:
			for _s_grid:_single_grid in _row:
				_s_grid.grid_type.pop_back()
				_s_grid.grid_type.append(_fast_type)
				

			
func try_add_chess(_pos:Vector2,_entity:ChessEntity):##通过鼠标全局位置种植一个植物，如果满足grid相关条件就种植
	##并返回true，否则返回false
	pass

		
func grid_clicked_mouseleft(_pos:Vector2):##被左键戳中
	var _type:_single_grid = get_clicked_single_grid(_pos)
	


func get_clicked_grid_pos(_pos:Vector2) ->Array[int]:##返回一个被点击到的single_grid相对坐标
	var _single_grid_size:Vector2 = Game.level_manager.curr_level.grid_manager.single_grid_size
	if _pos.x > global_position.x + collect_area.x or _pos.x < global_position.x or \
	_pos.y > global_position.y + collect_area.y or _pos.y < global_position.y:
		return[-1,-1]
	var _colomn:int = 0
	if single_grids.size() > 1:
		_colomn = single_grids[0].size()
	_pos = LawnObject.pos_skew_change(_pos,clct_area_skew_angle,_single_grid_size.x*float(_colomn)+global_position.x)
	var _pos_x:int = int((_pos.x-global_position.x)/_single_grid_size.x)
	var _pos_y:int = int((_pos.y-global_position.y)/_single_grid_size.y)
	return [_pos_x,_pos_y]
	
func get_clicked_single_grid(_pos:Vector2) -> _single_grid:##返回一个被点击到的single_grid
	var _pos_array:Array = get_clicked_grid_pos(_pos)
	if _pos_array[0] < 0:
		return null
	return single_grids[_pos_array[1]][_pos_array[0]]
	
func get_clicked_grid_center(_pos:Vector2):##根据点击坐标返回该格子中心真实坐标,偏移后的
	var _pos_array:Array = get_clicked_grid_pos(_pos)
	if _pos_array[0] < 0:
		return Vector2.ZERO
	var _single_grid_size:Vector2 = Game.level_manager.curr_level.grid_manager.single_grid_size
	var output:Vector2 = Vector2(global_position.x + float(_pos_array[0])*_single_grid_size.x,global_position.y + float(_pos_array[1])*_single_grid_size.y)
	output = LawnObject.pos_skew_change(output,clct_area_skew_angle,center_pos.x+grid_get_colomn()*_single_grid_size.x/2.0,true)
	return output

func grid_get_row() ->int:
	return single_grids.size()
	
func grid_get_colomn() ->int:
	var output:int = 0
	if single_grids.size() > 0:
		output = single_grids[0].size()
	return output	

func get_grid_zheight(_pos:Vector2):##输入一个物体的center_pos，获取他所处位置的地面z_height
	var _single_grid_size:Vector2 = Game.level_manager.curr_level.grid_manager.single_grid_size
	var _right_x:float = center_pos.x+grid_get_colomn()*_single_grid_size.x/2.0
	return z_height-tan(clct_area_skew_angle)*(_right_x - _pos.x)*Z_HEIGHT_FACTOR



enum GRID_TYPE{
	NONE,##虚空
	GRASS,##草皮，允许种植
	DISABLE,##禁用，往往使用在地块被非植物的实体占据时
	OCCUPY,##其他chessentity实体(通常是植物)占用
	WATER,##水
	LAVA,##熔岩
	BARE,##裸地
}


class _single_grid:##内部类型，会记住每个格子的chessentity
	var grid_change_entity:Array[ChessEntity] = []##地形改变类chessentity放在这个数组里
	var main_entity:Array[ChessEntity] = []##主要类型chessentity放在这个数组里
	var shell_entity:Array[ChessEntity] = []##外壳类型chessentity在这个数组里
	var flying_entity:Array[ChessEntity] = []##飞行类型chessentity
	var grid_type:Array[int] = []##地形数组，一般他的第0个元素是原始地形数据
	var grid_change_max:int = 2
	var main_max:int = 1
	var shell_max:int = 1
	var flying_max:int = 4
	
	static func create(_origin_type:int,_grid_change_max:int = 2,_main_max:int = 1,
	_shell_max:int = 1,_flying_max:int = 1) ->_single_grid:
		var new_single_grid:_single_grid = _single_grid.new()
		new_single_grid.grid_type.append(_origin_type)
		new_single_grid.grid_change_max = _grid_change_max
		new_single_grid.main_max = _main_max
		new_single_grid.shell_max = _shell_max
		new_single_grid.flying_max = _flying_max
		return new_single_grid
	
	func grid_pos_update(_add_pos:Vector2):
		for _entity:ChessEntity in grid_change_entity:
			_entity.global_position += _add_pos
		for _entity:ChessEntity in main_entity:
			_entity.global_position += _add_pos
		for _entity:ChessEntity in shell_entity:
			_entity.global_position += _add_pos
		for _entity:ChessEntity in flying_entity:
			_entity.global_position += _add_pos
			
	func try_add_entity(_entity:ChessEntity):
		match  _entity.chess_type:
			0:##grid_change类型
				if grid_change_entity.size() < grid_change_max and check_entity_need_type(_entity):
					grid_change_entity.append(_entity)
					return true
				else:
					return false
			1:##main类型
				if main_entity.size() < main_max and check_entity_need_type(_entity):
					main_entity.append(_entity)
					return true
				else:
					return false
			2:##shell类型
				pass
			3:##flying类型
				pass
	
	func try_shovel(_shovel_setting:Array = [ChessEntity.CHESS_TYPE.MAIN,ChessEntity.CHESS_TYPE.SHELL,
	ChessEntity.CHESS_TYPE.GRID_CHANGE,ChessEntity.CHESS_TYPE.FLYING]):
		##尝试铲除，会传入一个铲子的优先级函数,在最前面的会最优先铲除
		pass
		
	func get_entity():
		pass
	
	func get_curr_type() ->int:##获取当前格子的地形类型
		var _grid_type_size:int = grid_type.size()
		if _grid_type_size > 0:
			return grid_type[_grid_type_size - 1]
		else:
			grid_type.append(Grid.GRID_TYPE.NONE)
			return Grid.GRID_TYPE.NONE
			
	func check_entity_need_type(_entity:ChessEntity):##尝试了解当前地形是否适宜chessentity的种植
		var output:bool = false
		for _need_type:int in _entity.need_ground_type:
			if _need_type == get_curr_type():
				output = true
		return output
