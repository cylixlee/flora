extends Node
class_name ShaderManager

var shader_dic:Dictionary = {}
const file_folder_path:Array[String] = [
	"res://assets/flora/shader/"
]##记录着shader所在的文件夹的路径的数组，是文件夹的路径！！！
##务必保证该路径下就是shader，不要出现文件夹嵌套


func _ready():
	for _path in file_folder_path:
		load_all_shader_in_folder(_path)
	
func load_shader_from_path(_path:String):##暂时废弃
	pass
	
func load_all_shader_in_folder(_folder_path:String):
	if DirAccess.dir_exists_absolute(_folder_path):
		var _dir:DirAccess = DirAccess.open(_folder_path)
		if _dir:
			_dir.list_dir_begin()
			var _file_path:String = _dir.get_next()
			while _file_path != "":
				if _file_path.ends_with(".gdshader"):
					var _key_name:String = _file_path
					shader_dic[_key_name.replace(".gdshader","")] = load(_folder_path +"/"+_file_path)
				_file_path = _dir.get_next()
			_dir.list_dir_end()

func get_shader(_key_name:String):
	if shader_dic.has(_key_name):
		return shader_dic[_key_name]
