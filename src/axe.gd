class_name Axe
extends StaticBody2D

func pickup_obj():
	return OBJ.OBJ.AXE

func pickup():
	queue_free()
