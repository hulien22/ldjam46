extends Node2D

func _ready():
	set_camera_limits()

func _process(delta):
#	print($Player/Camera2D.global_position)
	pass

# setup camera limits
func set_camera_limits():
	var map_limits = $Map.get_used_rect()
	var map_cell_size = $Map.cell_size
	var map_scale = $Map.scale
	$YSort/Player/Camera2D.limit_left = map_limits.position.x * map_cell_size.x * map_scale.x
	$YSort/Player/Camera2D.limit_right = map_limits.end.x * map_cell_size.x * map_scale.x
	$YSort/Player/Camera2D.limit_top = map_limits.position.y * map_cell_size.y * map_scale.y
	$YSort/Player/Camera2D.limit_bottom = map_limits.end.y * map_cell_size.y * map_scale.y

