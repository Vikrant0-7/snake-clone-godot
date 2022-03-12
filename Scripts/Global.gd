extends Node

#classes
class Tiles:
	var occupied_tiles : Array

	func add_point(vec2 : Vector2) -> void:
		occupied_tiles.append(vec2)

	func remove_all() -> void:
		occupied_tiles.clear()

#signals
signal fruit_eaten() #emitted when food is eaten so that new food can spawn
signal update() #emitted after every "update_time" seconds. Most of game code works on it
signal last_tail_update() #emitted when snake is grown and snake has a new tail segment


#constants
const TILE_SIZE = 64 #tile size i.e. distance snake moves per update call. All objects in world exists in multiple of this
#texture constant
const tail : Texture = preload("res://Sprites/tail.png") #texture for tail of snake
const middle : Texture = preload("res://Sprites/middle.png") #texture for whole body of snake
const L_joint : Texture = preload("res://Sprites/L_joint.png") #texture of bending point of snake

#vars
var tiles : Tiles = Tiles.new() #stores tile class for proper food spawning
var update_time : float = 0.12 #time between two consecutive update calls
var timer : Timer #updates game logic every "update_time" seconds



func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",self,"_update")
	timer.start(update_time)

func _update() -> void:
	tiles.remove_all()
	emit_signal("update")
	timer.start(update_time)
