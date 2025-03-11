extends Node
class_name GridManager

var grids:Array[Grid] = []##存储所有grid的数组
var single_grid_size:Vector2 = Vector2.ZERO

signal gridmanager_finish_init##暂时废弃

func _ready():
	pass

func grid_manager_init():##初始化grid_manager,此函数于Level初始化之后调用
	var _grid_row:int = Game.level_manager.curr_level.grids_row
	var _grid_column:int = Game.level_manager.curr_level.grids_column
	var _pos_upleft:Vector2 = Game.level_manager.curr_level.grids_upleft_pos
	var _pos_downright:Vector2 = Game.level_manager.curr_level.grids_downright_pos
	var _pos_add_x:float = (_pos_downright.x - _pos_upleft.x)/(float(_grid_column))
	var _pos_add_y:float = (_pos_downright.y - _pos_upleft.y)/(float(_grid_row))
	single_grid_size = Vector2(_pos_add_x,_pos_add_y)
	for _grid_dic:Dictionary in Game.level_manager.curr_level_info.grid_value:
		var new_grid:Grid = Grid.create_grid(_grid_dic,single_grid_size)
		grids.append(new_grid)

func get_pos_from_dot(_vec2:Array) ->Vector2:
	##从一个点状vector2（如[0,0],[x,y]）里转化一个global_position（中心位置）出来
	##此函数不考虑地形偏移,会把地形转换成一个右对齐的全平面
	##请保证Level里的BackGroundLayer里的两个Marker是扭曲后的
	##不支持移动地形,这个函数只用于grid部署
	var _grid_row:int = Game.level_manager.curr_level.grids_row
	var _grid_column:int = Game.level_manager.curr_level.grids_column
	if _vec2[0] >= _grid_column or _vec2[0] < 0 or _vec2[1] >= _grid_row or _vec2[1] < 0:
		return Vector2.ZERO
	var _pos_upleft:Vector2 = Game.level_manager.curr_level.grids_upleft_pos
	var _pos_add_x:float = single_grid_size.x/2.0
	var _pos_add_y:float = single_grid_size.y/2.0
	return Vector2((float(_vec2[0])*2.0+1.0)*_pos_add_x,(float(_vec2[1])*2.0+1.0)*_pos_add_y) + _pos_upleft
	
func get_upleft_pos_from_dot(_vec:Array):
	##从一个点状vector2（如[0,0],[x,y]）里转化一个global_position（左上角位置）出来
	##此函数不考虑地形偏移
	return get_pos_from_dot(_vec) - single_grid_size/2.0
