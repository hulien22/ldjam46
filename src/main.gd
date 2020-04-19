extends Node2D

func _ready():
	set_camera_limits()
	GameGlobals.setDefaults()

func _process(delta):
	# check stuff
	if GameGlobals.ORBS_PLACED == 4:
		$YSort/altar.enable_runes(true)
		GameGlobals.ORBS_PLACED = 5
	if GameGlobals.ORBS_PLACED == 5 and $YSort/altar.hasFireChild():
		$YSort/altar.play_victory()
		GameGlobals.ORBS_PLACED = 6
		print($YSort/Player/Camera2D.position)
		# fix camera
		$YSort/Player/Camera2D.limit_left = 0
		$YSort/Player/Camera2D.limit_top = 0
		$YSort/Player/Camera2D.limit_right = 200
		$YSort/Player/Camera2D.limit_bottom = 100
	elif GameGlobals.FIRE_LEVEL == 0:
		# game over
		get_tree().paused = true
		$CanvasModulate.visible = false
		$GameOver.visible = true
		$GameOver/Camera2D.current = true
	elif Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = true
		$CanvasModulate.visible = false
		$Pause.visible = true
		$Pause/Camera2D.current = true
		


# setup camera limits
func set_camera_limits():
	var map_limits = $Map.get_used_rect()
	var map_cell_size = $Map.cell_size
	var map_scale = $Map.scale
	$YSort/Player/Camera2D.limit_left = map_limits.position.x * map_cell_size.x * map_scale.x
	$YSort/Player/Camera2D.limit_right = map_limits.end.x * map_cell_size.x * map_scale.x
	$YSort/Player/Camera2D.limit_top = map_limits.position.y * map_cell_size.y * map_scale.y
	$YSort/Player/Camera2D.limit_bottom = map_limits.end.y * map_cell_size.y * map_scale.y



func _on_Retry_pressed():
	get_tree().change_scene("res://src/intro.tscn")
	get_tree().paused = false

func _on_Menu_pressed():
	get_tree().change_scene("res://src/Menu.tscn")
	get_tree().paused = false


func _on_Resume_pressed():
	$CanvasModulate.visible = true
	$Pause.visible = false
	$YSort/Player/Camera2D.current = true
	get_tree().paused = false
