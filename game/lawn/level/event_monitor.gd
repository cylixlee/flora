extends Resource
## 关卡事件监听器,可以监听实体产生死亡，实体是否经过某个raycast之类的事情
class_name LevelEventMonitor

var event: EVENT


## 请使用静态方法获取 LevelEventMonitor
static func get_monitor():
	pass


func get_():
	pass


enum EVENT {
	RayCollid,
	Entity,
}
