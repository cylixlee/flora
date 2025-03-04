extends Node2D

@onready var show_sprite:Sprite2D = $ShowSprite
@onready var timer:Timer = $Timer
@onready var anim:AnimatedSprite2D = $SubViewport/AnimatedSprite2D

func _ready():
	timer.wait_time = 2.0
	timer.connect("timeout",show_be_attacked)
	timer.start()
	anim.play("idle",1.5)
	var new_shader:ShaderMaterial = ShaderMaterial.new()
	new_shader.shader = preload("res://temp/be_attacked.gdshader")
	show_sprite.material = new_shader
	show_sprite.material.resource_local_to_scene = true
	var new_color:Color = Color.WHITE
	new_color.a8 = 10
	new_shader.set_shader_parameter("blink_color",new_color)
	
	
	
	
func show_be_attacked():
	var tween:Tween = get_tree().create_tween()
	tween.tween_method(set_shader_intensity,1.0,0.0,0.6)
	
func set_shader_intensity(_value:float):
	show_sprite.material.set_shader_parameter("blink_intensity",_value)
