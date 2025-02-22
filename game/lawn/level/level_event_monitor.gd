extends Resource
class_name LevelEventMonitor
##关卡事件监听器,可以监听实体产生死亡，实体是否经过某个raycast之类的事情

var event:EVENT

static func get_monitor():##请使用静态方法获取
	pass

func get_():
	pass

enum EVENT{
	RayCollid,
	Entity,
}
