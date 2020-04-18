extends KinematicBody2D

export  (int) var speed

var velocity = Vector2()
var moving = false


func _physics_process(delta):
	velocity = Vector2(0,0)
	get_node("Arms").rotation_degrees = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		get_node("Body").set_flip_h(true)
		get_node("Arms").set_flip_h(true)
		get_node("Arms").rotate(0.5)
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		get_node("Body").set_flip_h(false)
		get_node("Arms").set_flip_h(false)
		get_node("Arms").rotate(-0.5)
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed

	if moving and velocity == Vector2(0,0):
		moving = false
		get_node("Legs/legsanim").stop(true)
		get_node("Legs").frame = 0
		get_node("Body/bodyanim").playback_speed = 1
		get_node("Arms/armsanim").playback_speed = 1
	elif not moving and velocity != Vector2(0,0):
		moving = true
		get_node("Legs/legsanim").play("legsanim", -1, 1.5)
		get_node("Body/bodyanim").playback_speed = 2
		get_node("Arms/armsanim").playback_speed = 2
		get_node("Arms").rotation_degrees = sign(velocity.x) * -1 * 15
	
	if velocity.x != 0 and velocity.y != 0:
		# normalize velocity
		var normvelocity = sqrt(speed*speed/2)
		velocity.x = sign(velocity.x) * normvelocity
		velocity.y = sign(velocity.y) * normvelocity
		
	move_and_slide(velocity)
