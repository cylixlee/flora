extends LawnObject
class_name PhysicObject

##碰撞箱中心位置会在ready的时候与center_marker同步
@export var physic_mode:PHYSIC_MODE = PHYSIC_MODE.NONE
@export var vertical_direction:Vector2 = Vector2(1,0)##垂直法线方向,用于弹性逻辑判断

var ground:Grid##对所处地面的引用
var gravity_able:bool = false##重力是否对其起作用,若为true会启用下坠，以及地板类型判定
@export var z_height:float = 0##伪z轴高度
var physic_area:Area2D##需要作为自身碰撞箱的Area2D被命名为"PhysicArea"
##保证physic_area的collsion_layer必须在1

const Z_TO_SPRITE_POS_FACTOR:float = 1.0
func _ready():
	super()
	for _node in get_children():
		if _node is Area2D and _node.name == "PhysicArea":
			physic_area = _node
			physic_area.collision_layer = 1
	if physic_area and center_marker:
		physic_area.global_position = center_marker.global_position

func _process(delta):
	super(delta)
	grid_update()
	showsprite_offset_update()

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


func showsprite_offset_update():##关于showsprite根据z_height的偏移
	if show_sprite and center_marker:
		var _ground_z:float = 0
		if ground:
			_ground_z = ground.get_grid_zheight(center_pos)
		show_sprite.position = center_marker.position + Vector2(0,-(z_height - _ground_z)*Z_TO_SPRITE_POS_FACTOR)
		
		










enum PHYSIC_MODE{
	RIGID,##刚体
	FLEXIBLE,##弹性
	NONE,##无碰撞
	OTHER##其他情况，会额外判断
}##模仿的物理类型
