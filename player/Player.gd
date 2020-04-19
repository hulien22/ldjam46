class_name Player
extends KinematicBody2D

# exports
export  (int) var speed
# properties
var velocity = Vector2()
var accelDir = Vector2(0,0)
var accelVal = 0
var moving = false
var held_object = OBJ.OBJ.NOTHING
var current_object = null
var last_dir = 0 # direction for attacks (rotation)
var attacking = false
var camera_shake = 0.0

func _ready():
	$ArmsHold/firechild.setCollision(false)

const FireChildInst = preload("res://src/FireChild.tscn")
const Slash = preload("res://src/Slash.tscn")
const Orb = preload("res://src/orb.tscn")
const Axe = preload("res://src/axe.tscn")
const Wood = preload("res://src/Wood.tscn")

func _physics_process(delta):
	
	# pickup / drop
	if Input.is_action_just_pressed("ui_pickup"):
		if held_object == OBJ.OBJ.NOTHING:
			# see if we can pickup an item
			var bodies = $PickupArea.get_overlapping_bodies()
			if not bodies.empty():
	#			# pick up closest item
				var min_dist = self.position.distance_squared_to(bodies[0].position)
				var min_i = 0
				for i in range(1, bodies.size()):
					var dist = self.position.distance_squared_to(bodies[i].position)
					if dist < min_dist:
						min_dist = dist
						min_i = i
				held_object = bodies[min_i].pickup_obj()
				# update view
				match held_object:
					OBJ.OBJ.FIRE_CHILD:
						if bodies[min_i] is Altar:
							$ArmsHold/firechild.setFire(bodies[min_i].get_node("FireChild").fire_level)
						else:
							$ArmsHold/firechild.setFire(bodies[min_i].fire_level)
						$ArmsHold/firechild.visible = true
					OBJ.OBJ.NOTHING:
						pass
					OBJ.OBJ.AXE:
						$ArmsHold/axe.visible = true
					OBJ.OBJ.ORB:
						$ArmsHold/orb.visible = true
					OBJ.OBJ.WOOD:
						$ArmsHold/wood.visible = true
				bodies[min_i].pickup()
		else:
			match held_object:
				OBJ.OBJ.FIRE_CHILD:
					var bodies = $PlaceArea.get_overlapping_bodies()
					if not bodies.empty() and bodies[0] is Altar:
						$ArmsHold/firechild.visible = false
						bodies[0].placeFireChild($ArmsHold/firechild.fire_level)
						held_object = OBJ.OBJ.NOTHING
				OBJ.OBJ.ORB:
					var bodies = $PlaceArea.get_overlapping_bodies()
					if not bodies.empty() and bodies[0] is Pedestal:
						$ArmsHold/orb.visible = false
						bodies[0].placeOrb()
						held_object = OBJ.OBJ.NOTHING
			drop_item()
	
	# interact (depends on item)
	if Input.is_action_just_pressed("ui_interact"):
		match held_object:
			OBJ.OBJ.AXE:
				if not attacking:
					attacking = true
					# summon slash
					var newSlash = Slash.instance()
					newSlash.scale = Vector2(2,2)
					get_parent().add_child(newSlash)
					newSlash.position = position * 2
					newSlash.set_as_toplevel(true)
					newSlash.damage = 10
					newSlash.rotate(last_dir)
					$AttackTimer.start(0.5)
					if $ArmsHold/axe.flip_h:
						$ArmsHold/swing.play_backwards("swing")
					else:
						$ArmsHold/swing.play("swing")
			OBJ.OBJ.WOOD:
				var bodies = $PlaceArea.get_overlapping_bodies()
				if not bodies.empty() and bodies[0] is FireChild:
					$ArmsHold/wood.visible = false
					bodies[0].raiseFire()
					held_object = OBJ.OBJ.NOTHING
			OBJ.OBJ.FIRE_CHILD:
				var bodies = $PlaceArea.get_overlapping_bodies()
				if not bodies.empty() and bodies[0] is Altar:
					$ArmsHold/firechild.visible = false
					bodies[0].placeFireChild($ArmsHold/firechild.fire_level)
					held_object = OBJ.OBJ.NOTHING
			OBJ.OBJ.ORB:
				var bodies = $PlaceArea.get_overlapping_bodies()
				if not bodies.empty() and bodies[0] is Pedestal:
					$ArmsHold/orb.visible = false
					bodies[0].placeOrb()
					held_object = OBJ.OBJ.NOTHING
			_:
				pass
			
#				var bodies = $PickupArea.get_overlapping_bodies()
#			for b in bodies:
#				if b.has_method("place_obj"):
#					b.place_obj()

	
	if held_object == OBJ.OBJ.NOTHING:
		$ArmsHold.visible = false
		$Arms.visible = true
	else:
		$ArmsHold.visible = true
		$Arms.visible = false
		
	# movement 
	velocity = accelVal * accelDir
	$Arms.rotation_degrees = 0
	if not attacking: # don't accept keyboard inputs if attacking
		if Input.is_action_pressed("ui_left"):
			velocity.x -= speed
			$Body.set_flip_h(true)
			$Arms.set_flip_h(true)
			$ArmsHold.set_flip_h(true)
			$ArmsHold/axe.set_flip_h(false)
			if held_object == OBJ.OBJ.NOTHING:
				$Arms.rotate(0.5)
			last_dir = PI
		if Input.is_action_pressed("ui_right"):
			velocity.x += speed
			$Body.set_flip_h(false)
			$Arms.set_flip_h(false)
			$ArmsHold.set_flip_h(false)
			$ArmsHold/axe.set_flip_h(true)
			if held_object == OBJ.OBJ.NOTHING:
				$Arms.rotate(-0.5)
			last_dir = 0
		if Input.is_action_pressed("ui_down"):
			velocity.y += speed
			last_dir = PI/2
		if Input.is_action_pressed("ui_up"):
			velocity.y -= speed
			last_dir = 3*PI/2

		if moving and velocity == Vector2(0,0):
			moving = false
			$Legs/legsanim.stop(true)
			$Legs.frame = 0
			$Body/bodyanim.playback_speed = 1
			$Arms/armsanim.playback_speed = 1
			$ArmsHold/armsanim.playback_speed = 1
		elif not moving and velocity != Vector2(0,0):
			moving = true
			$Legs/legsanim.play("legsanim", -1, 1.5)
			$Body/bodyanim.playback_speed = 2
			$Arms/armsanim.playback_speed = 2
			$ArmsHold/armsanim.playback_speed = 2
			if held_object == OBJ.OBJ.NOTHING:
				$Arms.rotation_degrees = sign(velocity.x) * -1 * 15
	
	if accelVal == 0 and velocity.x != 0 and velocity.y != 0:
		# normalize velocity
		var normvelocity = sqrt(speed*speed/2)
		velocity.x = sign(velocity.x) * normvelocity
		velocity.y = sign(velocity.y) * normvelocity

	move_and_slide(velocity)
		# update accel
	if accelVal > 0:
		accelVal /= 1.2
		accelVal -= 1
		if accelVal < 0:
			accelVal = 0

	
	
	# camera shake on hit
	if camera_shake > 0:
		$Camera2D.set_offset(
			Vector2(rand_range(-1.0, 1.0) * camera_shake, 
			rand_range(-1.0, 1.0) * camera_shake))
		camera_shake -= 0.5
		if camera_shake <= 0:
			camera_shake = 0
			$Camera2D.set_offset(Vector2(0,0))

func drop_item():
	match held_object:
		OBJ.OBJ.NOTHING:
			return
		OBJ.OBJ.FIRE_CHILD:
			$ArmsHold/firechild.visible = false
			var newObj = FireChildInst.instance()
			newObj.scale = Vector2(1,1)
			get_parent().add_child(newObj)
			newObj.setFire($ArmsHold/firechild.fire_level)
			newObj.global_position = global_position
			newObj.position.y += 5
		OBJ.OBJ.AXE:
			$ArmsHold/axe.visible = false
			var newObj = Axe.instance()
			newObj.scale = Vector2(0.5,0.5)
			get_parent().add_child(newObj)
			newObj.global_position = global_position
			newObj.position.y += 15
		OBJ.OBJ.ORB:
			$ArmsHold/orb.visible = false
			var newObj = Orb.instance()
			newObj.scale = Vector2(1,1)
			get_parent().add_child(newObj)
			newObj.global_position = global_position
			newObj.position.y += 15
		OBJ.OBJ.WOOD:
			$ArmsHold/wood.visible = false
			var newObj = Wood.instance()
			newObj.scale = Vector2(0.5,0.5)
			get_parent().add_child(newObj)
			newObj.global_position = global_position
			newObj.position.y += 15
	held_object = OBJ.OBJ.NOTHING

func _on_Hitbox_body_entered(body):
	if body is PurpleEnemy:
		match held_object:
			OBJ.OBJ.NOTHING:
				pass
			OBJ.OBJ.FIRE_CHILD:
				if accelVal == 0:
					$ArmsHold/firechild.lowerFire()
			_:
				# TODO can run into dropped obj
				#drop_item()
				pass
		
		var dir = (self.position - body.position).normalized()
		accelDir = dir
		accelVal = speed*10
		camera_shake = 5.0
			

func hasFireChild():
	return held_object == OBJ.OBJ.FIRE_CHILD

func _on_AttackTimer_timeout():
	attacking = false
