extends Node2D


var fruit_scene := preload("res://Scenes/Fruit.tscn")

export var bounds : NodePath
var bounds_rect : Rectangle

func _ready() -> void:
	$Label.text = str(get_viewport().size)
	bounds_rect = $Rectangle
	if bounds_rect == null:
		print("Not found at " + bounds)
		queue_free()
	Global.connect("fruit_eaten",self,"_on_fruit_eaten")
	_on_fruit_eaten()

func _on_fruit_eaten() -> void:
	randomize()
	var fruit : Fruit = fruit_scene.instance()
	call_deferred("add_child",fruit)
	fruit.create(bounds_rect)
