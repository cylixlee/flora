extends Node2D
class_name FindVision
##实现索敌功能
@onready var find_area:Area2D = $Area2D

func find_entity_update():
	var _areas:Array[Area2D] = find_area.get_overlapping_areas()
