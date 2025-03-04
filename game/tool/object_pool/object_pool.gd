extends Resource
class_name ObjectPool
##对象池
var pool_name:String = ""##对象池名字，与所包含的对象的pool_name相同
var objects:Array = []

func get_pool_size():
	return objects.size()
	
func get_object():
	if get_pool_size() > 0:
		return objects.pop_back()
		
func add_object(_object):
	objects.append(_object)
		
func clear_pool():
	for _object:Object in objects:
		if _object.has_method("queue_free"):
			_object.queue_free()
		else:
			_object.free()
			
static func create(_name:String):
	var new_pool:ObjectPool = ObjectPool.new()
	new_pool.pool_name = _name
	return new_pool
