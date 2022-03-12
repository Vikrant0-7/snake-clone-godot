extends StaticBody2D

class_name Tail

var is_last : bool = false

func _ready() -> void:
	Global.connect("update",self,"_update")

func _update() -> void:
	if not Global.is_connected("last_tail_update",self,"_last_tail_update"):
		Global.connect("last_tail_update",self,"_last_tail_update")
	global_position = global_position.snapped(Vector2.ONE * Global.TILE_SIZE)
	Global.tiles.add_point(global_position)
	if is_last:
		modulate = Color.green
	else:
		modulate = Color.white

func _last_tail_update() -> void:
	is_last = false
	print(is_last)
