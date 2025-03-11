extends Node
class_name GameTool

func area_get_entity(_area:Area2D,_get_owner:bool = true):##通过area2d获取其所属的实体
	##若_get_owner为true则返回area2d所属实体的obj_owner
	var _node:Node = _area
	while _node:
		_node = _node.get_parent()
		if _node is GameEntity:
			break
	if _get_owner:
		if _node.obj_owner:
			_node = _node.obj_owner
	return _node
	
