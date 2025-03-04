extends PhysicObject
class_name Grid
##grid_dic的范例
const GRID_DIC:Dictionary = {
	"init_pos":[0,0]
}


static func create_grid(grid_dic:Dictionary):
	if Game.level_manager.curr_level:
		var bg_layer:Node2D = Game.level_manager.curr_level.bg_layer
		var new_grid:Grid = Grid.create_from_gamescenes("OTHER","Grid",bg_layer)
		
