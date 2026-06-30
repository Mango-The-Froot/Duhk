extends CharacterBody2D

class_name RatEnemy

@onready var sprite = $AnimatedSprite2D

const speed = 100
var chasing: bool = false

var health = 20
var healthMax = 20
var healthMin = 0

var dead: bool = false
var damaged: bool = false
var attack = 2
var attacking: bool = false

var dir: Vector2
const gravity = 20
var kBForce = 100
var roaming: bool = true

func _process(delta):
	sprite.play("default")
	if velocity.x > 0:
		sprite.flip_h = true
	if velocity.x < 0:
		sprite.flip_h = false
	if !is_on_floor():
		velocity.y += gravity
		velocity.x = 0
	move(delta)
	move_and_slide()
	
func move(delta):
	if !dead:
		if !chasing:
			velocity += dir * speed * delta
		roaming = true
	elif dead:
		velocity.x = 0

func _on_direction_timeout():
	$Direction.wait_time = choose([1.5,2.0,2.5])
	if !chasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()
