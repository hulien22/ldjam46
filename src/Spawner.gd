class_name Spawner
extends Area2D

export (bool) var canSpawn = false
export (int) var spawnHealth = 30
export (int) var spawnSpeed = 50
export (float) var spawnSize = 1.2

const Enemy = preload("res://src/PurpleEnemy.tscn")

func _ready():
	$CollisionBox/CollisionShape2D.disabled = true

func _on_Spawner_body_exited(body):
	if not canSpawn:
		canSpawn = true
		$CollisionBox/CollisionShape2D.disabled = false
		$SpawnTimer.start(3)

func _on_SpawnTimer_timeout():
	$SpawnTimer.stop()
	if canSpawn:
		if GameGlobals.TOTAL_ENEMIES < GameGlobals.MAX_ENEMIES:
			GameGlobals.TOTAL_ENEMIES += 1
			var newEnemy = Enemy.instance()
			get_parent().add_child(newEnemy)
			newEnemy.scale = Vector2(spawnSize,spawnSize)
			newEnemy.speed = spawnSpeed
			newEnemy.health = spawnHealth
			newEnemy.global_position = global_position
			print(newEnemy.scale, newEnemy.speed, newEnemy.health)
		# go again
		$SpawnTimer.start(randi() % 10 + 25)
