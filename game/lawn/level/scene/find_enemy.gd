extends Node2D
class_name FindVision
##实现索敌功能
@onready var default_find_area:Area2D = $Area2D
@onready var update_time:int = 20
var row_on_entity:Array[GameEntity] = [null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null]##每一行最左边的引用

func find_entity_update():
	var _areas:Array[Area2D] = default_find_area.get_overlapping_areas()
	var _entitys:Array[GameEntity] = []
	for _area:Area2D in _areas:
		var _entity = Game.tool.area_get_entity(_area,false)
		if _entity.obj_owner:
			continue
		if not _entity is GameEntity:
			continue
		_entitys.append(_entity)
		
