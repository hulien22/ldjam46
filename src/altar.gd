class_name Altar
extends StaticBody2D

export (bool) var hasFireChild = true

func hasFireChild():
	return hasFireChild

func _ready():
	$FireChild.setCollision(false)
	$FireChild.setFireMedium()
	$FireChild.visible = true
	set_collision_layer_bit(4, true)
	set_collision_layer_bit(5, false)

func placeFireChild(fl):
	if not hasFireChild:
		$FireChild.setFire(fl)
		$FireChild.visible = true
		hasFireChild = true
		set_collision_layer_bit(4, true)
		set_collision_layer_bit(5, false)
		return true
	return false

func pickup_obj():
	if hasFireChild:
		return OBJ.OBJ.FIRE_CHILD
	return OBJ.OBJ.NOTHING


func pickup():
	if hasFireChild:
		hasFireChild = false
		set_collision_layer_bit(4, false)
		set_collision_layer_bit(5, true)
		$FireChild.visible = false

func enable_runes(val):
	$Runes.visible = val

func play_victory():
	set_collision_layer_bit(4, false)
	$VictoryCam.current = true
	$Light2D.visible = true
	$Victory.play("Victory")
	yield($Victory, "animation_finished")
	$Thanks.visible = true
	get_tree().paused = true
	


func _on_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://src/menu.tscn")
