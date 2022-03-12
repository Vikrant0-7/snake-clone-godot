extends Area2D

class_name Fruit

var glo_pos : Vector2
var timer : float = 0
var rect : Rectangle


func create(_rect : Rectangle) -> void:
	rect = _rect
	randomize()
	glo_pos = Vector2(
		round(rand_range(
			round(rect.get_lower_bound().x),
			round(rect.get_upper_bound().x)
		)),
		round(rand_range(
			round(rect.get_lower_bound().y),
			round(rect.get_upper_bound().y)
		))
	)
	glo_pos = glo_pos.snapped(Vector2.ONE * Global.TILE_SIZE)
	monitoring = false
	hide()
	if not Global.is_connected("update",self,"_update"):
		Global.connect("update",self,"_update")

func _update() -> void:
	var is_in_list : bool = false
	if not monitoring:
		for pos in Global.tiles.occupied_tiles:
			if abs(glo_pos.y - pos.y) < Global.TILE_SIZE / 3 and abs(glo_pos.x - pos.x) < Global.TILE_SIZE / 3:
				is_in_list = true
				break

	if timer > Global.update_time * 5 and is_in_list:
		create(rect)

	if not monitoring:
		timer += Global.update_time

	if not is_in_list and not monitoring:
		global_position = glo_pos
		timer = 0.0
		yield(get_tree().create_timer(rand_range(Global.update_time,Global.update_time * 2)),"timeout")
		monitoring = true
		show()



func _on_head_entered(area : Area2D) ->void:
	if area.is_in_group("Snake"):
		area.call("grow")
		Global.emit_signal("fruit_eaten")
		set_physics_process(false)
		queue_free()
