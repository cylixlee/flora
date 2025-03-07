extends GameEntity
class_name ChessEntity

@export var chess_type:CHESS_TYPE = CHESS_TYPE.MAIN
@export var need_ground_type:Array[int] = [Grid.GRID_TYPE.GRASS]##适宜地形有哪些
@export var change_grid_type:int = Grid.GRID_TYPE.OCCUPY ##可以把地形变成什么




enum CHESS_TYPE{##ChessEntity的类型
	GRID_CHANGE,##地形改变类
	MAIN,##主要类
	SHELL,##外壳类型
	FLYING,##飞行类型
}
