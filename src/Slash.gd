class_name Slash
extends Area2D

export (int) var damage = 10

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
