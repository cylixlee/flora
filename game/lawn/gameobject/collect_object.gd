extends LawnObject
class_name CollectObject

func _ready():
	super()
	left_mousebutton_pressed.connect(be_collect_mouseleft)
	right_mousebutton_pressed.connect(be_collect_mouseright)
	press_able = true


func be_collect_mouseleft():##被左键摁到
	pass

func be_collect_mouseright():
	pass
