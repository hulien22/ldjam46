extends StaticBody2D

export (int) var health = 50

const Wood = preload("res://src/Wood.tscn")

func destroy():
	queue_free()

func _on_Hitbox_area_entered(area):
	if area is Slash:
		health -= area.damage
		if health <= 0:
			# summon random 1- 3 wood and disappear
			$Hitbox.visible = false
			$Tree/Timber.play("timber")
			var numWood = randi() % 3 + 1
			for i in range(numWood):
				var newObj = Wood.instance()
				newObj.scale = Vector2(0.5,0.5)
				get_parent().add_child(newObj)
				newObj.global_position = global_position
				newObj.position.y += rand_range(-20,20)
				newObj.position.x += rand_range(-20,20)
				
		else:
			$Tree/Hit.play("hit", -1, 2.0)
		

func _on_Timber_animation_finished(anim_name):
	destroy()
