extends Node2D



func _on_Play_pressed():
	SceneTransition.change_scene("res://src/intro.tscn")


func _on_Controls_pressed():
	$Node2D.visible = false
	$Instructions.visible = true

func _on_HideInstr_pressed():
	$Node2D.visible = true
	$Instructions.visible = false
