class_name FireChild
extends KinematicBody2D

export (int) var fire_level = 1

var accelDir = Vector2(0,0)
var accelVal = 0

func _ready():
	setFireHigh()
	$CollisionShape2D.disabled = false
	$Hitbox/CollisionShape2D.disabled = false

func hasFireChild():
	return true

func setFire(fl):
	if fl == 0:
		GameGlobals.FIRE_LEVEL = 0
	elif fl == 0.25:
		setFireVeryLow()
	elif fl == 0.5:
		setFireLow()
	elif fl ==0.75:
		setFireLowMedium()
	elif fl == 1:
		setFireMedium()
	elif fl == 1.25:
		setFireMediumHigh()
	else:
		setFireHigh()

func setFireVeryLow():
	fire_level = 0.25
	$Body/happy.stop()
	$Body/meh.stop()
	$Body/sad.play("sad")
	$Fire.scale = Vector2(fire_level, fire_level)
	GameGlobals.FIRE_LEVEL = fire_level
	
func setFireLow():
	fire_level = 0.5
	$Body/happy.stop()
	$Body/meh.stop()
	$Body/sad.play("sad")
	$Fire.scale = Vector2(fire_level, fire_level)
	GameGlobals.FIRE_LEVEL = fire_level

func setFireLowMedium():
	fire_level = 0.75
	$Body/happy.stop()
	$Body/sad.stop()
	$Body/meh.play("meh")
	$Fire.scale = Vector2(fire_level, fire_level)
	GameGlobals.FIRE_LEVEL = fire_level

func setFireMedium():
	fire_level = 1
	$Body/happy.stop()
	$Body/sad.stop()
	$Body/meh.play("meh")
	$Fire.scale = Vector2(fire_level, fire_level)
	GameGlobals.FIRE_LEVEL = fire_level

func setFireMediumHigh():
	fire_level = 1.25
	$Body/meh.stop()
	$Body/sad.stop()
	$Body/happy.play("happy")
	$Fire.scale = Vector2(fire_level, fire_level)
	GameGlobals.FIRE_LEVEL = fire_level

func setFireHigh():
	fire_level = 1.5
	$Body/meh.stop()
	$Body/sad.stop()
	$Body/happy.play("happy")
	$Fire.scale = Vector2(fire_level, fire_level)
	GameGlobals.FIRE_LEVEL = fire_level

func lowerFire():
	setFire(fire_level - 0.25)
	
func raiseFire():
	setFire(fire_level + 0.5)
	$Fire/raise.play("raise", -1, 2)

func setCollision(val):
	$CollisionShape2D.disabled = !val
	$Hitbox/CollisionShape2D.disabled = !val

func pickup_obj():
	return OBJ.OBJ.FIRE_CHILD

func pickup():
	queue_free()

func _on_Hitbox_body_entered(body):
	if body is PurpleEnemy:
		if accelVal == 0:
			lowerFire()
		var dir = (self.position - body.position).normalized()
		accelDir = dir
		accelVal = 200*10
		body.accelDir = - accelDir
		body.accelVal = body.speed * 4 * 10

func _physics_process(delta):
	var velocity = (accelVal / 10) * accelDir
	move_and_slide(velocity)
	# update accel
	if accelVal > 0:
		accelVal /= 1.2
		accelVal -= 1
		if accelVal < 0:
			accelVal = 0
