extends LawnObject
class_name PhysicObject

@export var physic_mode:PHYSIC_MODE = PHYSIC_MODE.NONE
@export var vertical_direction:Vector2 = Vector2(1,0)##垂直法线方向,用于弹性逻辑判断

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
