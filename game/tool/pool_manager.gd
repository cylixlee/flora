extends Node
class_name PoolManager
##对象池
var pool_dic:Dictionary = {}

func get_object_from_pool(_name:String):
	if has_object(_name):
		return pool_dic[_name].get_object()
		
func has_object(_name:String) -> bool:
	if pool_dic.has(_name):
		if pool_dic[_name].get_pool_size() > 0:
			return true
	return false
	
func add_object(_object:LawnObject):
	if not pool_dic.has(_object.pool_name):
		pool_dic[_object.pool_name] = ObjectPool.create(_object.pool_name)
		
	pool_dic[_object.pool_name].add_object(_object)

func clear_all_pools():
	for _pool_key:String in pool_dic.keys():
		pool_dic[_pool_key].clear_pool()
		pool_dic[_pool_key].free()
	pool_dic.clear()
