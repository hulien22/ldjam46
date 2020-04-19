class_name Wood
extends StaticBody2D

func pickup_obj():
	return OBJ.OBJ.WOOD

func pickup():
	queue_free()
