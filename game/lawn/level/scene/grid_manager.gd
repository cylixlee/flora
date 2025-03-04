extends Node
class_name GridManager

var grids:Array[Grid] = []##存储所有grid的数组


func _ready():
	pass


func get_pos_from_dot(_vec2:Array) ->Vector2:
	##从一个点状vector2（如[0,0],[x,y]）里转化一个global_position（中心位置）出来
	var _grid_row:int = Game.level_manager.curr_level.grids_row
	var _grid_column:int = Game.level_manager.curr_level.grids_column
	if _vec2[0] >= _grid_column or _vec2[0] < 0 or _vec2[1] >= _grid_row or _vec2[1] < 0:
		return Vector2.ZERO
	var _pos_upleft:Vector2 = Game.level_manager.curr_level.grids_upleft_pos
	var _pos_downright:Vector2 = Game.level_manager.curr_level.grids_downright_pos
	var _pos_add_x:float = (_pos_downright.x - _pos_upleft.x)/(float(_grid_column)*2.0)
	var _pos_add_y:float = (_pos_downright.y - _pos_upleft.y)/(float(_grid_row)*2.0)
	return Vector2((float(_vec2[0])*2.0+1.0)*_pos_add_x,(float(_vec2[1])*2.0+1.0)*_pos_add_y) + _pos_upleft
	
