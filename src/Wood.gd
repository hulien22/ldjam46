class_name Wood
extends StaticBody2D

func _ready():
	$DecayTimer.start(120)

func pickup_obj():
	return OBJ.OBJ.WOOD

func pickup():
	queue_free()

func _on_DecayTimer_timeout():
	queue_free()
