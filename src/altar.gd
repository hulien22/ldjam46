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
