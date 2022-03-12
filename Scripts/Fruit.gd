extends Area2D

class_name Fruit

var glo_pos : Vector2
var timer : float = 0
var rect : Rectangle

#randomly decides positon of fruit
func create(_rect : Rectangle) -> void:
	rect = _rect #rect is used to define bounds for fruit spawning
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
	) #generates position
	glo_pos = glo_pos.snapped(Vector2.ONE * Global.TILE_SIZE) #snaps to generated position to grid
	monitoring = false
	hide()
	if not Global.is_connected("update",self,"_update"):
		Global.connect("update",self,"_update")


func _update() -> void:
	var is_in_list : bool = false

	#checks if fruit will spawn on snake's body
	if not monitoring:
		for pos in Global.tiles.occupied_tiles:
			if abs(glo_pos.y - pos.y) < Global.TILE_SIZE / 3 and abs(glo_pos.x - pos.x) < Global.TILE_SIZE / 3:
				is_in_list = true
				break

	#if fruit is spawning of snake's body for 5 consecutive update calls
	#generate a new position for it
	if timer > Global.update_time * 5 and is_in_list:
		create(rect)

	if not monitoring:
		timer += Global.update_time

	#show fruit if not spawning on snake's body
	if not is_in_list and not monitoring:
		global_position = glo_pos
		timer = 0.0
		yield(get_tree().create_timer(rand_range(Global.update_time,Global.update_time * 2)),"timeout")
		monitoring = true
		show()


#logic after snake's head touches fruit
func _on_head_entered(area : Area2D) ->void:
	if area.is_in_group("Snake"):
		area.call("grow")
		Global.emit_signal("fruit_eaten")
		set_physics_process(false)
		queue_free()
