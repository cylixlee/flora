extends LawnObject
class_name PhysicObject

##碰撞箱中心位置会在ready的时候与center_marker同步
@export var physic_mode:PHYSIC_MODE = PHYSIC_MODE.NONE
@export var vertical_direction:Vector2 = Vector2(1,0)##垂直法线方向,用于弹性逻辑判断

var ground:Grid##对所处地面的引用
var gravity_able:bool = false##重力是否对其起作用,若为true会启用下坠，以及地板类型判定
var z_height:int ##伪z轴高度
var physic_area:Area2D##需要作为自身碰撞箱的Area2D被命名为"PhysicArea"

func _ready():
	super()
	for _node in get_children():
		if _node is Area2D and _node.name == "PhysicArea":
			physic_area = _node
	if physic_area and center_marker:
		physic_area.global_position = center_marker.global_position

func _process(delta):
	super(delta)
	grid_update()

func grid_update():##检测地面
	if self is ChessEntity or self is Grid or obj_owner:
		return
	if not physic_area:
		return
	if not center_marker:
		return
	var _grids:Array[Grid] = Game.level_manager.curr_level.grid_manager.grids
	var _check:bool = false
	for _grid:Grid in _grids:
		if _grid.pos_in_area(center_pos):
			ground = _grid
			_check = true
	if not _check:
		ground = null
		
	
	

func get_rebound_direction(_direct:Vector2)->Vector2:##假如自身是弹性的，可以通过这个获取一个以_direct方向飞过来的实体的反弹方向
	var vertical_angle:float = vertical_direction.angle()
	if vertical_angle >=179.99:
		vertical_angle -=180.00
	return Vector2.from_angle(2.0*vertical_angle-_direct.angle())


	










enum PHYSIC_MODE{
	RIGID,##刚体
	FLEXIBLE,##弹性
	NONE,##无碰撞
	OTHER##其他情况，会额外判断
}##模仿的物理类型
