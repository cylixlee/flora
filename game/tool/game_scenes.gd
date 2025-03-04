extends Node
class_name GameScenes
##记录所有游戏内可用的lawn_object派生类型
##可通过get_packedscene获取任意派生类型的PackedScene


const load_dic = preload("res://resource/constant/gameload_scenes.gd")
const DEFAULT_PACKED_SCENE:PackedScene = preload("res://temp/shader_example.tscn")
var packed_scenes:Dictionary = {}##字典套字典，外层key为group_name，里层key为实体自己的名字，例如"peashooter"
var curr_loading_scenes:Array[_LoadingScene] = []
var wait_to_delete_in_loading_scenes:Array[int] = []
@export var dynamic_load_mode:bool = false##若为true将会动态加载（也就是即用即加载）

func _ready():
	if not dynamic_load_mode:
		init_load_scene()
	
func _process(delta):
	loader_update()	

func load_scene(_path:String,_group_name:String,_key_name:String = ""):
	if not _path.ends_with(".tscn"):
		return
	if not FileAccess.file_exists(_path):
		return
	if _key_name == "":
		var _path_split:Array = _path.split("/")
		for _split:String in _path_split:
			if _split.ends_with(".tscn"):
				_key_name = _split.replace(".tscn","")
	var new_packedscene:PackedScene
	ResourceLoader.load_threaded_request(_path)
	curr_loading_scenes.append(_LoadingScene.create(_path,_group_name,_key_name))
	
func add_loaded_packed_scene(_packed_scene:PackedScene,_group_name:String,_key_name:String):
	if not packed_scenes.has(_group_name):
		packed_scenes[_group_name] = {}
	packed_scenes[_group_name][_key_name] = _packed_scene

func init_load_scene():##初始加载函数，游戏刚开始运行时会执行，如果dynamic_load_mode为true则不调用
	for _group_name:String in load_dic.DICTIONARY.keys():
		if _group_name.ends_with("_FOLDER"):
			var _group_name_true:String = _group_name.replace("_FOLDER","")
			for _path:String in load_dic.DICTIONARY[_group_name]:
				var _result:Array[String] = []
				get_all_need_path(_path,".tscn",_result)
				for _tscn_path:String in _result:
					load_scene(_tscn_path,_group_name_true)
								
		else:
			for _path:String in load_dic.DICTIONARY[_group_name]:
				load_scene(_path,_group_name)
	
func get_packedscene(_key_name:String,_group_name:String = "") ->PackedScene:
	if packed_scenes.has(_group_name):
		if packed_scenes[_group_name].has(_key_name):
			return packed_scenes[_group_name][_key_name]
	return DEFAULT_PACKED_SCENE

func loader_update():
	#wait_to_delete_in_loading_scenes.clear()
	for i in range(curr_loading_scenes.size()-1,-1,-1):
		if ResourceLoader.load_threaded_get_status(curr_loading_scenes[i].path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			add_loaded_packed_scene(ResourceLoader.load_threaded_get(curr_loading_scenes[i].path),curr_loading_scenes[i].group_name,curr_loading_scenes[i].key_name)
			curr_loading_scenes.remove_at(i)
	#for j in wait_to_delete_in_loading_scenes:
		#curr_loading_scenes.remove_at(j)
		
func get_all_need_path(_folder_path:String,_need_end:String,_result:Array[String] = []):##
	##获取全部的文件夹下的以_need_end结尾的文件路径，添加在_result中
	var _dir:DirAccess = DirAccess.open(_folder_path)
	if _dir:
		_dir.list_dir_begin()
		var _file_path:String = _dir.get_next()
		while _file_path != "":
			if _file_path.count(".") == 0:##文件路径里没有"."，说明是文件夹
				get_all_need_path(_folder_path+"/"+_file_path,_need_end,_result)
			else:
				if _file_path.ends_with(_need_end):
					_result.append(_folder_path+"/"+_file_path)
			_file_path = _dir.get_next()

class _LoadingScene:##内部类型，代表一个正在加载的委托
	var path:String = ""
	var group_name:String = ""
	var key_name:String = ""
	static func create(_path:String,_group_name:String,_key_name:String) ->_LoadingScene:
		var new_loading_scene:_LoadingScene = _LoadingScene.new()
		new_loading_scene.path = _path
		new_loading_scene.group_name = _group_name
		new_loading_scene.key_name = _key_name
		return new_loading_scene
