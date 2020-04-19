extends Node2D

var accept_keystrokes = false

func _ready():
	$AcceptKeystrokesTimer.start(1)
	$Label/Text.play("text")

func _on_AcceptKeystrokes_timeout():
	accept_keystrokes = true

func _process(delta):
	if accept_keystrokes and Input.is_action_just_pressed("ui_pickup"):
		accept_keystrokes = false
		$Label/Text.stop()
		$Label.percent_visible = 0.865
		$Label/FadeOut.play("fade")
		yield($Label/FadeOut, "animation_finished")
		get_tree().change_scene("res://src/main.tscn")
