class_name PurpleEnemy
extends KinematicBody2D

export (int) var health
export (int) var speed

var accelDir = Vector2(0,0)
var accelVal = 0

func _ready():
	health = 30
	speed = 50

func destroy():
	queue_free()

func _on_Hitbox_area_entered(area):
	if area is Slash:
		var dir = (2*position - area.position).normalized()
		accelDir = dir
		accelVal = (speed * 4) * 10
		health -= area.damage
		if health <= 0:
			$Hitbox.visible = false
			$DeathFade.play("fade", -1, 2)


func _physics_process(delta):
	var velocity = accelVal * accelDir
	# find FireChild and chase
	var fc_posn = Vector2(0,0)
	for c in get_parent().get_children():
		# hack for now to get around circular dependencies
		if c.has_method("hasFireChild") and c.hasFireChild():
			fc_posn = c.position
			break

	var dir = (fc_posn - position).normalized()
	velocity += dir * speed
	
	move_and_slide(velocity)
	# update accel
	if accelVal > 0:
		accelVal /= 1.2
		accelVal -= 1
		if accelVal < 0:
			accelVal = 0


func _on_DeathFade_animation_finished(anim_name):
	destroy()
