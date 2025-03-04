extends Node2D
class_name LawnObject

###玩法相关逻辑变量===================================================
@export var lawn_group:LAWN_GROUP = LAWN_GROUP.NONE##草坪实体中，他属于什么类型

###其他变量=====================================
var obj_owner:LawnObject##如果属于另一个lawnobject派生类型，则保存其主人的引用
var color_filter:Array[Color]##附加颜色数组

var center_pos:Vector2 = Vector2.ZERO##中心位置，相当于这个object的下属marker(必须名为CenterMarker)的全局位置,自动获取
@export var collect_area:Vector2 = Vector2.ZERO##可以获取鼠标输入的范围大小，自动往四周延申，矩形
var object_state:OBJECT_STATE = OBJECT_STATE.SLEEP##实体状态



@export var press_able:bool = false##是否对玩家的输入行为敏感
var animation_player:AnimationPlayer##两种类型的动画节点
var animated_sprite:AnimatedSprite2D##两种类型的动画节点
var sub_viewport:SubViewport
var show_sprite:Sprite2D
##请保证lawnobject的全部派生类型在场景下具备一个名为"ShowSprite"的Sprite2D节点作为直接子节点,和一个SubViewport作为直接子节点
##将所有的美术素材放在Subviewport下面,仅有美术，动画相关素材会放在subviewport下面!!!!
signal left_mousebutton_pressed
signal right_mousebutton_pressed
func _ready():
	object_state = OBJECT_STATE.PREPARING
	for node in get_children():
		if node is SubViewport:
			sub_viewport = node
		if node is Sprite2D and node.name == "ShowSprite":
			show_sprite = node
		if node is Marker2D and node.name == "CenterMarker":
				center_pos = node.global_position
	
	if sub_viewport:		
		for node in sub_viewport.get_children():
			if node is AnimationPlayer:
				animation_player = node
			if node is AnimatedSprite2D:
				animated_sprite = node
				
func _process(delta):
	color_update()
	
func _init():
	process_thread_group = PROCESS_THREAD_GROUP_MAIN_THREAD
	if sub_viewport:
		sub_viewport.process_thread_group = Node.PROCESS_THREAD_GROUP_SUB_THREAD
	if show_sprite:
		show_sprite.process_thread_group = Node.PROCESS_THREAD_GROUP_SUB_THREAD
	
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
		left_mousebutton_pressed.emit()
	
func be_pressed_mouseright(_pos:Vector2):##自身被右键摁到的函数
	if pos_in_area(_pos):
		#print("pressed by right")
		right_mousebutton_pressed.emit()

func pos_in_area(_pos:Vector2)->bool:##检测一个vector2代表的全局坐标是否在自身area内部
	var _pos_upleft_x:float = center_pos.x - collect_area.x*0.5
	var _pos_upleft_y:float = center_pos.y - collect_area.y*0.5
	var _pos_downright_x:float = center_pos.x + collect_area.x*0.5
	var _pos_downright_y:float = center_pos.y + collect_area.y*0.5
	if _pos.x >= _pos_upleft_x and _pos.x <= _pos_downright_x and _pos.y>=_pos_upleft_y and _pos.y<=_pos_downright_y:
		return true
	else:
		return false
		
##==================动画相关===========================
func anim_play(_anim_name:String,_play_speed:float):##一个中间函数
	if animated_sprite:
		animated_sprite.play(_anim_name,_play_speed)
	else:
		if animation_player:
			animation_player.play(_anim_name,-1,_play_speed)

##==================生命周期相关===========================
func enter_game():##开启游戏性交互功能，一般调用在程序层面的初始化结束
	if not object_state == OBJECT_STATE.PREPARING:
		return
	object_state = OBJECT_STATE.NORMAL
	
func leave_game():##关闭游戏性交互功能，一般调用在游戏中所对应的对象死亡
	if not object_state == OBJECT_STATE.NORMAL:
		return
	object_state = OBJECT_STATE.DYING		
	

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
