class_name Orb
extends KinematicBody2D

func _ready():
	enable_light(false)

func pickup_obj():
	return OBJ.OBJ.ORB

func pickup():
	queue_free()

func enable_light(val):
	$Light2D.visible = val
