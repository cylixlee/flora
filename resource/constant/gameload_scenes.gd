extends Resource
##GameScenes会加载的全部LawnObject派生类型
const DICTIONARY:Dictionary = {
	"PLANT":[
		
	],
	"ZOMBIE":[
		
	],
	"PLANT_FOLDER":[
		
	],
	"OTHER":[
		"res://game/lawn/gameobject/grid/Grid.tscn"
	]
}##以字典中键值为"group_name",value为包含需要加载的tscn文件绝对路径的数组为格式
##快速加载模式，你可以将字典中的键值设置为以_FOLDER为结尾，在数组内填入一个文件夹绝对路径，会自行加载该文件夹下所有的.tscn文件
