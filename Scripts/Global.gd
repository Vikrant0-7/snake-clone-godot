extends Node

class Tiles:
	var occupied_tiles : Array

	func add_point(vec2 : Vector2) -> void:
		occupied_tiles.append(vec2)

	func remove_all() -> void:
		occupied_tiles.clear()

var tiles : Tiles = Tiles.new()

const TILE_SIZE = 64
signal fruit_eaten()
signal update
signal last_tail_update()
var update_time : float = 0.12
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",self,"_update")
	timer.start(update_time)

func _update() -> void:
	tiles.remove_all()
	emit_signal("update")
	timer.start(update_time)
