extends CanvasLayer

onready var animPlayer = $Fade

func change_scene(path):
	animPlayer.play("fade", -1, 0.5)
	yield(animPlayer, "animation_finished")
	animPlayer.play("unfade", -1, 0.5)
	get_tree().change_scene(path)
	yield(animPlayer, "animation_finished")
