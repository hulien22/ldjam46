class_name Pedestal
extends StaticBody2D

export (bool) var hasOrb = false

func _ready():
	hasOrb = false
	$Body/Glyphs.frame = 0
	$Body/Orb.visible = false

func placeOrb():
	hasOrb = true
	$Body/Glyphs.frame = 1
	$Body/Orb.visible = true
	set_collision_layer_bit(5, false)
	GameGlobals.ORBS_PLACED += 1
