extends Node2D

@onready var button:Button = $Button
var level_info:LevelInfo = preload("res://temp/resource/default_level.tres")

func  _ready():
	button.connect("pressed",try_enter_level)

func try_enter_level():
	Level.enter(LevelInfo.new())
