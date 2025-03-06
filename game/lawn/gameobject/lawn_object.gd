extends Node2D
class_name LawnObject

###玩法相关逻辑变量===================================================
@export var object_name:String = ""
@export var lawn_group:LAWN_GROUP = LAWN_GROUP.NONE##草坪实体中，他属于什么类型

###其他变量=====================================
var obj_owner:LawnObject##如果属于另一个lawnobject派生类型，则保存其主人的引用
var color_filter:Array[Color]##附加颜色数组

##中心位置，相当于这个object的下属marker(必须名为CenterMarker)的全局位置,自动获取
var center_pos:Vector2:get = get_center_pos
func get_center_pos() ->Vector2:
	if center_marker:
		return center_marker.global_position
	else:
		return Vector2.ZERO
var center_marker:Marker2D
@export var collect_area:Vector2 = Vector2.ZERO##可以获取鼠标输入的范围大小，自动往四周延申，矩形
@export var clct_area_skew_angle:float = 0##检测点击范围倾斜角，不会影响到他的横向长度
var object_state:OBJECT_STATE = OBJECT_STATE.SLEEP##实体状态
@export var has_pool:bool = false##是否是池化对象，若为true会自动出入池子
@export var pool_name:String = ""##所属池子的名字,务必保证一个池子里所有实体都是同一个类型



@export var press_able:bool = false##是否对玩家的输入行为敏感
@export var show_press_arae:bool = false##显示检测玩家输入区域
var animation_player:AnimationPlayer##两种类型的动画节点
var animated_sprite:AnimatedSprite2D##两种类型的动画节点
var sub_viewport:SubViewport
var show_sprite:Sprite2D

const BLINK_SHADER_NAME:String = "blink"
##请保证lawnobject的全部派生类型在场景下具备一个名为"ShowSprite"的Sprite2D节点作为直接子节点,和一个SubViewport作为直接子节点
##将所有的美术素材放在Subviewport下面,仅有美术，动画相关素材会放在subviewport下面!!!!
signal left_mousebutton_pressed(_pos:Vector2)
signal right_mousebutton_pressed(_pos:Vector2)
func _ready():##请勿使用instantiate()创建lawnobject派生
	object_state = OBJECT_STATE.PREPARING
	process_mode = PROCESS_MODE_DISABLED##ready时会默认关闭_process
	for node in get_children():
		if node is SubViewport:
			sub_viewport = node
		if node is Sprite2D and node.name == "ShowSprite":
			show_sprite = node
		if node is Marker2D and node.name == "CenterMarker":
			center_marker = node
	
	if sub_viewport:		
		for node in sub_viewport.get_children():
			if node is AnimationPlayer:
				animation_player = node
			if node is AnimatedSprite2D:
				animated_sprite = node
				
	if pool_name == "":
		pool_name = object_name
	set_thread()
	shader_init()
	anim_init()
	
				
func _process(delta):
	color_update()
	
func set_thread():
	process_thread_group = PROCESS_THREAD_GROUP_MAIN_THREAD
	if sub_viewport:
		sub_viewport.process_thread_group = Node.PROCESS_THREAD_GROUP_SUB_THREAD
	if show_sprite:
		show_sprite.process_thread_group = Node.PROCESS_THREAD_GROUP_SUB_THREAD
	
static func create_from_path(_path:String,_owner_node:Node):##通过绝对路径创建LawnObject
	pass	
	
static func create_from_gamescenes(_group_name:String,_key:String,_owner_node:Node)->LawnObject:
##通过GameScenes创建LawnObject,会自行加入对应node
	var new_scene:LawnObject = Game.game_scenes.get_packedscene(_key,_group_name).instantiate()
	_owner_node.add_child(new_scene)
	new_scene.enter_game()
	return new_scene


## ==========一些每帧都要运行的函数==============================
func color_update():
	if not show_sprite:
		return
	var new_color:Color = Color.WHITE
	for _color:Color in color_filter:
		new_color *= _color
	show_sprite.modulate = new_color
		
## ==========一些关于鼠标输入方面的函数==========================			
func _unhandled_input(event):
	if press_able:
		if event is InputEventMouse:
			if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
				be_pressed_mouseleft(event.global_position)
			if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
				be_pressed_mouseright(event.global_position)
	
	
func be_pressed_mouseleft(_pos:Vector2):##自身被左键摁到的函数，传入鼠标位置
	if pos_in_area(_pos):
		#print("pressed by left")
		left_mousebutton_pressed.emit(_pos)
	
func be_pressed_mouseright(_pos:Vector2):##自身被右键摁到的函数
	if pos_in_area(_pos):
		#print("pressed by right")
		right_mousebutton_pressed.emit(_pos)

func pos_in_area(_pos:Vector2)->bool:##检测一个vector2代表的全局坐标是否在自身area内部
	var _pos_upleft_x:float = center_pos.x - collect_area.x*0.5
	var _pos_upleft_y:float = center_pos.y - collect_area.y*0.5
	var _pos_downright_x:float = center_pos.x + collect_area.x*0.5
	var _pos_downright_y:float = center_pos.y + collect_area.y*0.5
	_pos = LawnObject.pos_skew_change(_pos,clct_area_skew_angle,_pos_downright_x)
	if _pos.x >= _pos_upleft_x and _pos.x <= _pos_downright_x and _pos.y>=_pos_upleft_y and _pos.y<=_pos_downright_y:
		return true
	else:
		return false
		
static func pos_skew_change(_pos:Vector2,_skew_angle:float,_right_border_x:float) ->Vector2:
	##静态函数，输入需要改变的位置，倾斜角，以及右侧边界，返回一个右侧边界不变情况下的倾斜操作后的位置
	
	return Vector2(_pos.x,_pos.y-tan(_skew_angle)*(_right_border_x-_pos.x))
##==================动画相关===========================
func shader_init():##Shader初始化,_ready时运行
	if show_sprite:
		show_sprite.material = ShaderMaterial.new()
		show_sprite.material.resource_local_to_scene = true
	
func anim_init():##动画初始化,_ready时运行
	pass

func anim_play(_anim_name:String,_play_speed:float):##一个中间函数,调用动画函数改变播放的动画
	if animated_sprite:
		animated_sprite.call_deferred("play",_anim_name,_play_speed)
	else:
		if animation_player:
			animation_player.call_deferred("play",_anim_name,-1,_play_speed)
			
func blink(_color:Color = Color.WHITE):##使实体发光
	if show_sprite:
		show_sprite.material.shader = Game.shader_manager.get_shader(BLINK_SHADER_NAME)
		show_sprite.material.shader.set_shader_parameter("blink_color",_color)
		get_tree().create_tween().tween_method(tween_do_blink,1.0,0,0.6)
	
func tween_do_blink(_value:float):##本函数由tween调用
	if show_sprite:
		show_sprite.material.shader.set_shader_parameter("blink_intensity",_value)

##==================生命周期相关===========================
func enter_game():##开启游戏性交互功能，一般调用在程序层面的初始化结束,此时Object通常已经进入场景树
	##一般来说请复写此函数，不要复写静态函数create_from_xxx()
	if not object_state == OBJECT_STATE.PREPARING:
		return
	object_state = OBJECT_STATE.NORMAL
	process_mode = PROCESS_MODE_INHERIT
	
func leave_game():##关闭游戏性交互功能，一般调用在游戏中所对应的对象死亡
	if not object_state == OBJECT_STATE.NORMAL:
		return
	object_state = OBJECT_STATE.DYING		
	if has_pool:
		pass
	
	

enum LAWN_GROUP{
	PLANT,
	ZOMBIE,
	COLLECTION,
	OTHER,
	NONE
}
enum OBJECT_STATE{
	PREPARING,##准备中，一般用于实体正在实例化，或者入池状态，一般无法进行游戏性交互
	NORMAL,##正常运行，可以正常地进行游戏性交互
	DYING,##死亡中，不可进行游戏性交互，一般是死亡动画播放状态，或者等待queue_free，返回池
	SLEEP##睡眠，一般是在对象池中,不可进行游戏性交互
}
