extends CharacterBody2D

class_name BossRat

@onready var sprite = $AnimatedSprite2D

const speed = 100
var chasing: bool = false

var health
var healthMax = 100
var healthMin = 0

var dead: bool = false
var damaged: bool = false
var attack = 2
var attacking: bool = false

var dir: Vector2
const gravity = 20
var kBForce = -400
var roaming: bool = true

var player: CharacterBody2D
var playerInArea = false


func _ready():
	health = 20 * scale.x
	attack = 5 * scale.x / 2


func _process(delta):
	if !is_on_floor():
		velocity.y += gravity
		velocity.x = 0
		
	player = GlobalVar.playerBody
	GlobalVar.bossRatDmgZone = $BossRatDamageZone
	GlobalVar.bossRatDmg = attack
	if health <= 0:
		dead = true
	
	move(delta)
	handleAnimation()
	move_and_slide()

func move(delta):
	if position.distance_to(player.position) < 400:
		roaming = false
		chasing = true
	else:
		chasing = false
		roaming = true
	
	if !dead:
		if !chasing:
			velocity += dir * speed * delta
		elif chasing && !damaged:
			var playerDir = position.direction_to(player.position) * speed
			velocity.x = playerDir.x
		elif damaged:
			var KBDir = position.direction_to(player.position) * kBForce
			velocity.x = KBDir.x
		roaming = true
	elif dead:
		velocity.x = 0

func handleAnimation():
	var animSprite = $AnimatedSprite2D
	if !dead && !damaged && !attacking:
		animSprite.play("Walk")
		if velocity.x > 0:
			sprite.flip_h = true
		if velocity.x < 0:
			sprite.flip_h = false
	elif !dead && damaged && !attacking:
		animSprite.play("Hurt")
		await get_tree().create_timer(.8)
		damaged = false
	elif dead && !roaming:
		roaming = false
		animSprite.play("Death")
		await get_tree().create_timer(1.0).timeout
		handleDeath()
	elif !dead && attacking:
		animSprite.play("Attack")

func handleDeath():
	self.queue_free()

func _on_direction_timeout():
	$Direction.wait_time = choose([1.5,2.0,2.5])
	if !chasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()

func _set_health(value):
	$healthBar._set_health(value)


func _on_rat_hit_box_area_entered(area):
	var damage = GlobalVar.playerDamage
	if area == GlobalVar.playerDamageZone:
		takeDamage(damage)

func takeDamage(damage):
	health -= damage
	damaged = true
	if health <= healthMin:
		health = healthMin
		dead = true
	print(str(self), health)


func _on_rat_damage_zone_area_entered(area):
	if area == GlobalVar.playerHitbox:
		attacking = true
		await get_tree().create_timer(1.0).timeout
		attacking = false
