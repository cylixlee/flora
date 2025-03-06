extends GameEntity
class_name ChessEntity

@export var chess_type:CHESS_TYPE = CHESS_TYPE.MAIN




enum CHESS_TYPE{##ChessEntity的类型
	GRID_CHANGE,##地形改变类
	MAIN,##主要类
	SHELL,##外壳类型
	FLYING,##飞行类型
}
