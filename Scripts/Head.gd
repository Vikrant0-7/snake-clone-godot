extends Area2D

export var fixed_update_time : float = 0.04

var direction : Vector2 = Vector2.ZERO
var segments : Array
var tail_segment_scene := preload("res://Scenes/tail.scn")
var length : int



func _ready() -> void:
	global_position = global_position.snapped(Vector2.ONE * Global.TILE_SIZE)
	global_position += Vector2.ONE * Global.TILE_SIZE/2
	segments.append(self)
	Global.connect("update",self,"_update")

func _physics_process(delta: float) -> void:
	handle_input()

func handle_input() -> void:
	if direction.length_squared() == 0:
		if Input.is_action_pressed("left"):
			direction = Vector2.LEFT
		elif Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
		elif Input.is_action_pressed("up"):
			direction = Vector2.UP
		elif Input.is_action_pressed("down"):
			direction = Vector2.DOWN
	elif direction.x == 0:
		if Input.is_action_pressed("left"):
			direction = Vector2.LEFT
		if Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
	elif direction.y == 0:
		if Input.is_action_pressed("up"):
			direction = Vector2.UP
		if Input.is_action_pressed("down"):
			direction = Vector2.DOWN


func _update() -> void:
	if direction == Vector2.ZERO: return
	Global.tiles.add_point(global_position)
	move_tail_segment()
	move()
	snap_to_grid()
	rotation = direction.angle()


func move() -> void:
	global_position = Vector2(
		global_position.round().x + direction.x * Global.TILE_SIZE,
		global_position.round().y + direction.y * Global.TILE_SIZE
		)


func move_tail_segment() -> void:
	for i in range(segments.size() - 1,0,-1):
		segments[i].global_position = segments[i - 1].position

#snaps movement of snake to the grid
func snap_to_grid() -> void:
	if global_position.x < get_parent().bounds_rect.get_lower_bound().x:
		global_position.x = round(global_position.x + get_parent().bounds_rect.get_upper_bound().x)
	elif global_position.x > get_parent().bounds_rect.get_upper_bound().x:
		global_position.x = round(global_position.x - get_parent().bounds_rect.get_upper_bound().x)
	if global_position.y < get_parent().bounds_rect.get_lower_bound().y:
		global_position.y = round(global_position.y + get_parent().bounds_rect.get_upper_bound().y)
	elif global_position.y > get_parent().bounds_rect.get_upper_bound().y:
		global_position.y = round(global_position.y-get_parent().bounds_rect.get_upper_bound().y)
	global_position = global_position.snapped(Vector2.ONE * Global.TILE_SIZE)


#adds a segment to grow the snake
func grow() -> void:
	var tail_segment : StaticBody2D = tail_segment_scene.instance()
	tail_segment.global_position = segments[segments.size() - 1].global_position
	if length < 2:
		tail_segment.layers = 0b1000
	$NotMovable.call_deferred("add_child",tail_segment)
	segments.append(tail_segment)
	Global.emit_signal("last_tail_update")
	tail_segment.is_last = true
	length += 1

#kills snake if it hits its tail of a wall
func _on_Head_body_entered(body: Node) -> void:
	if body.is_in_group("tail"):
		direction = Vector2.ZERO
