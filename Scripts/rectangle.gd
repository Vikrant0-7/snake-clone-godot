extends Line2D

class_name Rectangle

#sorts lower and upper bound
func _ready() -> void:
	if (points[0] as Vector2).length_squared() > (points[1] as Vector2).length_squared():
		var point = points[0]
		points[0] = points[1]
		points[1] = point

func get_lower_bound() -> Vector2:
	return points[0]

func get_upper_bound() -> Vector2:
	return points[1]
