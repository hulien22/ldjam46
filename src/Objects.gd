extends Node2D

func _process(delta):
	get_children()
	for node in get_children():
		node.z_index = node.position.y

